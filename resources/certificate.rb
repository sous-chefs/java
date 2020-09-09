#
# Author:: Mevan Samaratunga (<mevansam@gmail.com>)
# Author:: Michael Goetz (<mpgoetz@gmail.com>)
# Cookbook:: java
# Resource:: certificate
#
# Copyright:: 2013, Mevan Samaratunga
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
property :cert_alias, String,
  name_property: true,
  description: 'The alias of the certificate in the keystore. This defaults to the name of the resource'

property :java_home, String,
  default: lazy { node['java']['java_home'] },
  description: 'The java home directory'

property :java_version, String,
  default: lazy { node['java']['jdk_version'] },
  description: 'The java version'

property :keystore_path, String,
  description: 'Path to the keystore'

property :keystore_passwd, String,
  default: 'changeit',
  description: 'Password to the keystore'

property :cert_data, String,
  description: 'The certificate data to install'

property :cert_file, String,
  description: 'Path to a certificate file to install'

property :ssl_endpoint, String,
  description: 'An SSL end-point from which to download the certificate'

property :starttls, String,
  equal_to: %w(smtp pop3 imap ftp xmpp xmpp-server irc postgres mysql lmtp nntp sieve ldap),
  description: 'A protocol specific STARTTLS argument to use when fetching from an ssl_endpoint'

action :install do
  require 'openssl'

  java_home = new_resource.java_home
  Chef::Log.info java_home
  keytool = "#{java_home}/bin/keytool"
  truststore = if new_resource.keystore_path.nil?
                 truststore_default_location
               else
                 new_resource.keystore_path
               end
  truststore_passwd = new_resource.keystore_passwd
  certalias = new_resource.cert_alias
  certdata = new_resource.cert_data || fetch_certdata

  hash = OpenSSL::Digest::SHA512.hexdigest(certdata)
  certfile = "#{Chef::Config[:file_cache_path]}/#{certalias}.cert.#{hash}"
  cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -rfc -alias \"#{certalias}\"")
  cmd.run_command
  keystore_cert = cmd.stdout.match(/^[-]+BEGIN.*END(\s|\w)+[-]+$/m).to_s

  keystore_cert_digest = keystore_cert.empty? ? nil : OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(keystore_cert).to_der)
  certfile_digest = OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(certdata).to_der)
  if keystore_cert_digest == certfile_digest
    Chef::Log.debug("Certificate \"#{certalias}\" in keystore \"#{truststore}\" is up-to-date.")
  else
    cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v")
    cmd.run_command
    Chef::Log.info(cmd.format_for_exception)
    Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

    has_key = !cmd.stdout[/Alias name: \b#{certalias}\s*$/i].nil?

    if has_key
      converge_by("delete existing certificate #{certalias} from #{truststore}") do
        cmd = Mixlib::ShellOut.new("#{keytool} -delete -alias \"#{certalias}\" -keystore #{truststore} -storepass #{truststore_passwd}")
        cmd.run_command
        Chef::Log.debug(cmd.format_for_exception)
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Error deleting existing certificate \"#{certalias}\" in " \
              "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
        end
      end
    end

    ::File.open(certfile, 'w', 0o644) { |f| f.write(certdata) }

    converge_by("add certificate #{certalias} to keystore #{truststore}") do
      cmd = Mixlib::ShellOut.new("#{keytool} -import -trustcacerts -alias \"#{certalias}\" -file #{certfile} -keystore #{truststore} -storepass #{truststore_passwd} -noprompt")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)

      unless cmd.exitstatus == 0
        FileUtils.rm_f(certfile)
        Chef::Application.fatal!("Error importing certificate into keystore: #{cmd.exitstatus}", cmd.exitstatus)
      end
    end
  end
end

action :remove do
  certalias = new_resource.name
  truststore = if new_resource.keystore_path.nil?
                 truststore_default_location
               else
                 new_resource.keystore_path
               end
  truststore_passwd = new_resource.keystore_passwd
  keytool = "#{new_resource.java_home}/bin/keytool"

  cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v | grep \"#{certalias}\"")
  cmd.run_command
  has_key = !cmd.stdout[/Alias name: #{certalias}/].nil?
  does_not_exist = cmd.stdout[/Alias <#{certalias}> does not exist/].nil?
  Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless (cmd.exitstatus == 0) || does_not_exist

  if has_key
    converge_by("remove certificate #{certalias} from #{truststore}") do
      cmd = Mixlib::ShellOut.new("#{keytool} -delete -alias \"#{certalias}\" -keystore #{truststore} -storepass #{truststore_passwd}")
      cmd.run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Error deleting existing certificate \"#{certalias}\" in " \
            "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
      end
    end
  end

  FileUtils.rm_f("#{Chef::Config[:file_cache_path]}/#{certalias}.cert.*")
end

action_class do
  def fetch_certdata
    return IO.read(new_resource.cert_file) unless new_resource.cert_file.nil?

    certendpoint = new_resource.ssl_endpoint
    starttls = new_resource.starttls.nil? ? '' : "-starttls #{new_resource.starttls}"
    unless certendpoint.nil?
      cmd = Mixlib::ShellOut.new("echo QUIT | openssl s_client -showcerts -servername #{certendpoint.split(':').first} -connect #{certendpoint} #{starttls} 2> /dev/null | openssl x509")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)

      Chef::Application.fatal!("Error returned when attempting to retrieve certificate from remote endpoint #{certendpoint}: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

      certout = cmd.stdout
      return certout unless certout.empty?
      Chef::Application.fatal!("Unable to parse certificate from openssl query of #{certendpoint}.", 999)
    end

    Chef::Application.fatal!('At least one of cert_data, cert_file or ssl_endpoint attributes must be provided.', 999)
  end

  def truststore_default_location
    if new_resource.java_version.to_i > 8
      "#{new_resource.java_home}/lib/security/cacerts"
    else
      "#{new_resource.java_home}/jre/lib/security/cacerts"
    end
  end
end
