# frozen_string_literal: true

provides :java_certificate
unified_mode true
include Java::Cookbook::CertificateHelpers
include Java::Cookbook::OpenJdkHelpers

property :cert_alias,
          String,
          regex: /\A[A-Za-z0-9_.-]+\z/,
          name_property: true,
          description: 'The alias of the certificate in the keystore. This defaults to the name of the resource'

property :java_version,
          String,
          default: '17',
          description: 'The major java version'

property :java_home,
          String,
          default: lazy { default_openjdk_pkg_java_home(java_version) },
          description: 'The java home directory'

property :cacerts,
          [true, false],
          default: true,
          description: 'Specify true for interacting with the Java installation cacerts file. (Java 9+)'

property :keystore_path,
          String,
          default: lazy { default_truststore_path(java_version, java_home) },
          description: 'Path to the keystore'

property :keystore_passwd,
          String,
          default: 'changeit',
          description: 'Password to the keystore'

property :cert_data,
          String,
          description: 'The certificate data to install'

property :cert_file,
          String,
          description: 'Path to a certificate file to install'

property :ssl_endpoint,
          String,
          callbacks: {
            'must be a host:port endpoint' => lambda { |endpoint|
              endpoint.match?(/\A[A-Za-z0-9.-]+:\d+\z/)
            },
          },
          description: 'An SSL end-point from which to download the certificate'

property :starttls,
          String,
          equal_to: %w(smtp pop3 imap ftp xmpp xmpp-server irc postgres mysql lmtp nntp sieve ldap),
          description: 'A protocol specific STARTTLS argument to use when fetching from an ssl_endpoint'

property :file_cache_path,
          String,
          default: Chef::Config[:file_cache_path],
          description: 'Location to store certificate files'

action :install do
  require 'openssl'

  keystore_arguments = keystore_argument(new_resource.cacerts, new_resource.keystore_path)

  certdata = new_resource.cert_data || fetch_certdata

  hash = OpenSSL::Digest::SHA512.hexdigest(certdata)
  certfile = ::File.join(new_resource.file_cache_path, "#{new_resource.cert_alias}.cert.#{hash}")

  cmd = keytool('-list', *keystore_arguments, '-storepass', new_resource.keystore_passwd, '-rfc', '-alias', new_resource.cert_alias)
  cmd.run_command
  keystore_cert = cmd.stdout.match(/^[-]+BEGIN.*END(\s|\w)+[-]+$/m).to_s

  keystore_cert_digest = keystore_cert.empty? ? nil : OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(keystore_cert).to_der)
  certfile_digest = OpenSSL::Digest::SHA512.hexdigest(OpenSSL::X509::Certificate.new(certdata).to_der)
  if keystore_cert_digest == certfile_digest
    Chef::Log.debug("Certificate \"#{new_resource.cert_alias}\" in keystore \"#{new_resource.keystore_path}\" is up-to-date.")
  else
    cmd = keytool('-list', *keystore_arguments, '-storepass', new_resource.keystore_passwd, '-v')
    cmd.run_command
    Chef::Log.debug(cmd.format_for_exception)
    Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

    has_key = !cmd.stdout[/Alias name: \b#{Regexp.escape(new_resource.cert_alias)}\s*$/i].nil?

    if has_key
      converge_by("delete existing certificate #{new_resource.cert_alias} from #{new_resource.keystore_path}") do
        cmd = keytool('-delete', '-alias', new_resource.cert_alias, *keystore_arguments, '-storepass', new_resource.keystore_passwd)
        cmd.run_command
        Chef::Log.debug(cmd.format_for_exception)
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Error deleting existing certificate \"#{new_resource.cert_alias}\" in " \
              "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
        end
      end
    end

    ::FileUtils.mkdir_p(new_resource.file_cache_path)
    ::File.open(certfile, 'w', 0o644) { |f| f.write(certdata) }

    converge_by("add certificate #{new_resource.cert_alias} to keystore #{new_resource.keystore_path}") do
      cmd = keytool('-import', '-trustcacerts', '-alias', new_resource.cert_alias, '-file', certfile, *keystore_arguments, '-storepass', new_resource.keystore_passwd, '-noprompt')
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
  keystore_arguments = keystore_argument(new_resource.cacerts, new_resource.keystore_path)

  cmd = keytool('-list', *keystore_arguments, '-storepass', new_resource.keystore_passwd, '-v')
  cmd.run_command
  has_key = !cmd.stdout[/Alias name: #{Regexp.escape(new_resource.cert_alias)}/].nil?
  does_not_exist = cmd.stdout[/Alias <#{Regexp.escape(new_resource.cert_alias)}> does not exist/]
  Chef::Application.fatal!("Error querying keystore for existing certificate: #{cmd.exitstatus}", cmd.exitstatus) unless (cmd.exitstatus == 0) || does_not_exist

  if has_key
    converge_by("remove certificate #{new_resource.cert_alias} from #{new_resource.keystore_path}") do
      cmd = keytool('-delete', '-alias', new_resource.cert_alias, *keystore_arguments, '-storepass', new_resource.keystore_passwd)
      cmd.run_command
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Error deleting existing certificate \"#{new_resource.cert_alias}\" in " \
            "keystore so it can be updated: #{cmd.exitstatus}", cmd.exitstatus)
      end
    end
  end

  FileUtils.rm_f(::Dir.glob(::File.join(new_resource.file_cache_path, "#{new_resource.cert_alias}.cert.*")))
end

action_class do
  def keytool(*args)
    Mixlib::ShellOut.new(::File.join(new_resource.java_home, 'bin', 'keytool'), *args)
  end

  def fetch_certdata
    return IO.read(new_resource.cert_file) unless new_resource.cert_file.nil?

    certendpoint = new_resource.ssl_endpoint
    unless certendpoint.nil?
      host = certendpoint.split(':').first
      starttls = new_resource.starttls.nil? ? [] : ['-starttls', new_resource.starttls]
      cmd = Mixlib::ShellOut.new('openssl', 's_client', '-showcerts', '-servername', host, '-connect', certendpoint, *starttls, input: "QUIT\n", timeout: 30)
      cmd.run_command
      Chef::Log.debug(cmd.format_for_exception)

      Chef::Application.fatal!("Error returned when attempting to retrieve certificate from remote endpoint #{certendpoint}: #{cmd.exitstatus}", cmd.exitstatus) unless cmd.exitstatus == 0

      certout = cmd.stdout[/-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m].to_s
      return certout unless certout.empty?
      Chef::Application.fatal!("Unable to parse certificate from openssl query of #{certendpoint}.", 999)
    end

    Chef::Application.fatal!('At least one of cert_data, cert_file or ssl_endpoint attributes must be provided.', 999)
  end
end
