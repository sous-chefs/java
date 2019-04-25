#
# Author:: Mevan Samaratunga (<mevansam@gmail.com>)
# Author:: Michael Goetz (<mpgoetz@gmail.com>)
# Author:: Chris Drzewiecki (<chris@fdisk.io>)
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

property :java_home, String, default: lazy { node['java']['java_home'] }
property :keystore_path, String, default: lazy { node['java']['jdk_version'].to_i < 11 ? "#{node['java']['java_home']}/jre/lib/security/cacerts" : "#{node['java']['java_home']}/lib/security/cacerts" }
property :keystore_passwd, String, default: 'changeit'
property :cert_alias, String, name_property: true
property :cert_data, String
property :cert_file, String
property :ssl_endpoint, String
property :cert_type, String, default: 'file', equal_to: %w(file keystore)
property :source_keystore_path, String
property :source_keystore_passwd, String
property :source_cert_alias, String

action :install do
  require 'openssl'

  cert_type = new_resource.cert_type
  java_home = new_resource.java_home
  keytool = "#{java_home}/bin/keytool"
  truststore = if new_resource.keystore_path.empty?
                 truststore_default_location
               else
                 new_resource.keystore_path
               end
  truststore_passwd = new_resource.keystore_passwd
  dest_keystore = Keystore.new(truststore, truststore_passwd)

  if cert_type == 'file'
    certalias = new_resource.cert_alias
    certdata = new_resource.cert_data || fetch_certdata

    hash = OpenSSL::Digest::SHA512.hexdigest(certdata)
    certfile = "#{Chef::Config[:file_cache_path]}/#{certalias}.cert.#{hash}"
    keystore_cert = get_keystore_cert(certalias, dest_keystore)

    keystore_cert_digest = keystore_cert.empty? ? nil : OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(keystore_cert).to_der)
    certfile_digest = OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(certdata).to_der)
    if keystore_cert_digest == certfile_digest
      Chef::Log.debug("Certificate \"#{certalias}\" in keystore \"#{truststore}\" is up-to-date.")
    else
      cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)
      Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

      has_key = !cmd.stdout[/Alias name: \b#{certalias}/i].nil?

      delete_keystore_cert(certalias, dest_keystore) if has_key

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
  else
    if new_resource.source_keystore_path.nil?
      Chef::Application.fatal!('source_keystore_path is a required parameter when cert_type is keystore')
    end
    if new_resource.source_keystore_passwd.nil?
      Chef::Application.fatal!('source_keystore_passwd is a required parameter when cert_type is keystore')
    end

    src_path = new_resource.source_keystore_path
    src_password = new_resource.source_keystore_passwd
    src_keystore = Keystore.new(src_path, src_password)

    if new_resource.source_cert_alias.nil?
      Chef::Log.debug('source_cert_alias was not provided, we will import every cert from the source keystore')

      read_all_certs().each do |cert_alias|
        converge_keystore_cert(cert_alias, src_keystore, cert_alias, dest_keystore)
      end
    else
      src_alias = new_resource.source_cert_alias
      dest_alias = new_resource.cert_alias
      converge_keystore_cert(src_alias, src_keystore, dest_alias, dest_keystore)
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
  keytool = "#{node['java']['java_home']}/bin/keytool"

  cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{truststore} -storepass #{truststore_passwd} -v | grep \"#{certalias}\"")
  cmd.run_command
  has_key = !cmd.stdout[/Alias name: #{certalias}/].nil?
  Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

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
  class Keystore
    attr_accessor :path, :password

    def initialize(path, password)
      @path = path
      @password = password
    end

    def to_s
      @path
    end
  end

  def fetch_certdata
    return IO.read(new_resource.cert_file) unless new_resource.cert_file.nil?

    certendpoint = new_resource.ssl_endpoint
    unless certendpoint.nil?
      cmd = Mixlib::ShellOut.new("echo QUIT | openssl s_client -showcerts -servername #{certendpoint.split(':').first} -connect #{certendpoint} 2> /dev/null | openssl x509")
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
    if node['java']['jdk_version'].to_i > 8
      "#{node['java']['java_home']}/lib/security/cacerts"
    else
      "#{node['java']['java_home']}/jre/lib/security/cacerts"
    end
  end

  def read_all_certs
    src_keystore = new_resource.source_keystore_path
    src_password = new_resource.source_keystore_passwd
    keytool = "#{node['java']['java_home']}/bin/keytool"

    unless src_keystore.nil? || src_password.nil?
      cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{src_keystore} -v -storepass '#{src_password}' | grep 'Alias name:' | awk '{ print $3; }'")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)

      Chef::Application.fatal!('Error when attempting to retrieve cert aliases from source keystore!') unless cmd.exitstatus == 0

      cert_aliases = cmd.stdout.split
      return cert_aliases unless cert_aliases.empty?
      Chef::Application.fatal!("No cert aliases found when parsing #{src_keystore}.")
    end

    Chef::Application.fatal!('Both source_keystore_path and source_keystore_passwd must be provided when the cert type is keystore.')
  end

  def get_keystore_cert(cert_alias, keystore)
    java_home = new_resource.java_home
    keytool = "#{java_home}/bin/keytool"

    cmd = Mixlib::ShellOut.new("#{keytool} -list -keystore #{keystore.path} -storepass #{keystore.password} -rfc -alias \"#{cert_alias}\"")
    cmd.run_command
    keystore_cert = cmd.stdout.match(/^[-]+BEGIN.*END(\s|\w)+[-]+$/m).to_s

    keystore_cert
  end

  def delete_keystore_cert(cert_alias, keystore)
    java_home = new_resource.java_home
    keytool = "#{java_home}/bin/keytool"

    converge_by("Delete existing certificate #{cert_alias} from #{keystore}") do
      cmd = Mixlib::ShellOut.new("#{keytool} -delete -alias \"#{cert_alias}\" -keystore #{keystore.path} -storepass #{keystore.password}")
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Error deleting certificate #{cert_alias} from keystore #{keystore}: #{cmd.exitstatus}", cmd.exitstatus)
      end
    end
  end

  def converge_keystore_cert(src_alias, src_keystore, dest_alias, dest_keystore)
    java_home = new_resource.java_home
    keytool = "#{java_home}/bin/keytool"
    src_cert = get_keystore_cert(src_alias, src_keystore)
    dest_cert = get_keystore_cert(dest_alias, dest_keystore)

    insert_cert = false

    if dest_cert.empty? || dest_cert.nil?
      insert_cert = true
    elsif src_cert == dest_cert
      Chef::Log.debug("Certificate \"#{dest_alias}\" in keystore \"#{dest_keystore}\" is up-to-date.")
    else
      delete_keystore_cert(dest_alias, dest_keystore)
      insert_cert = true
    end

    if insert_cert
      converge_by("Add certificate #{src_alias} from keystore #{src_keystore} to keystore #{dest_keystore} as #{dest_alias}") do
        cmd = Mixlib::ShellOut.new("#{keytool} -importkeystore -srckeystore '#{src_keystore.path}' -srcstorepass '#{src_keystore.password}' -srcalias '#{src_alias}' -destkeystore '#{dest_keystore.path}' -deststorepass '#{dest_keystore.password}' -destalias '#{dest_alias}'")
        cmd.run_command()
        Chef::Log.debug(cmd.format_for_exception)

        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Error importing certificate #{dest_alias} into keystore #{dest_keystore}: #{cmd.exitstatus}", cmd.exitstatus)
        end
      end
    end
  end
end
