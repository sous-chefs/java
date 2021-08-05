variant = input('variant', description: 'Variant being used: openj9, openj9-large-heap, or hotspot')
java_version = input('java_version', description: 'Which version of java should be installed')
certificate_sha256_checksum = input('certificate_sha256_checksum',
                                        value: '64:F3:3B:A7:EF:C3:5C:6B:2D:ED:95:0B:CB:4E:96:3B:12:97:B8:62:BA:1A:8E:30:13:B0:B0:59:77:12:31:EA',
                                        description: 'The SHA256 checksum of the certificate'
)
parent_install_dir = input('parent_install_dir',
                      value: "java-#{java_version.to_i > 8 ? java_version.to_i : java_version.split('.')[1]}-adoptopenjdk-#{variant}",
                      description: 'The parent of the Java home')
keystore_location = input('keystore_location',
                              value: nil,
                              description: 'Where the java keystore is located'
)
keystore_password = input('keystore_password',
                              value: 'changeit',
                              description: 'Password to the Java keystore')

control 'check-java-version' do
  impact 1.0
  title 'Verify java version'
  desc 'Verify the correct version of java is installed'

  describe command('java -version 2>&1') do
    its('stdout') { should match /AdoptOpenJDK/ } unless java_version.to_i == 1
    its('stdout') { should match Regexp.new(java_version.to_s) }
  end
end

if os.linux?
  control 'check-java-alternatives' do
    impact 1.0
    title 'Verify alternatives for java'
    desc 'Verify alternatives for java are set to the correct version'

    %w(jar jarsigner java javac).each do |cmd|
      describe command("update-alternatives --display #{cmd}") do
        its('stdout') { should match parent_install_dir.to_s }
      end
    end
  end
end

control 'check-jce' do
  impact 1.0
  title 'Verify JCE is Unlimitied'
  desc 'Verify JCE unlimited support and string'

  describe command('java -jar /tmp/UnlimitedSupportJCETest.jar') do
    its('stdout') { should match /isUnlimitedSupported=TRUE/ }
    its('stdout') { should match /strength: 2147483647/ }
  end
end

control 'check-certificate' do
  impact 1.0
  title 'Verify Java keystore contains the certificate'
  desc 'Verify Java keystore exists and contains the certificate'

  unless certificate_sha256_checksum.nil? || certificate_sha256_checksum.empty?
    cmd = "keytool -list -v -keystore #{keystore_location}"
    cmd.concat(" -storepass #{keystore_password}") unless keystore_password.nil?
    describe command("#{cmd} | grep SHA256:") do
      its('stdout') { should match certificate_sha256_checksum }
    end
  end
end

if os.darwin?
  control 'JAVA_HOME' do
    impact 0.1
    title 'Verify the JAVA_HOME is set correctly'
    desc 'Verify that JAVA_HOME is set correctly and to the correct version in the bash profile'

    describe file('/etc/profile') do
      its('content') { should match /JAVA_HOME/ }
    end
  end
end
