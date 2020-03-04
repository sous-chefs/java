variant = attribute('variant', description: 'Variant being used: openj9, openj9-large-heap, or hotspot')
java_version = attribute('java_version', description: 'Which version of java should be installed')
certificate_sha256_checksum = attribute('certificate_sha256_checksum',
                                        value: '64:F3:3B:A7:EF:C3:5C:6B:2D:ED:95:0B:CB:4E:96:3B:12:97:B8:62:BA:1A:8E:30:13:B0:B0:59:77:12:31:EA',
                                        description: 'The SHA256 checksum of the certificate'
                                       )
install_flavor = attribute('install_flavor',
                           value: 'adoptopenjdk',
                           description: 'The installation flavor used to install java')

parent_install_dir = attribute('parent_install_dir',
                      value: "java-#{java_version.to_i > 8 ? java_version.to_i : java_version.split('.')[1]}-#{install_flavor}-#{variant}",
                      description: 'The parent of the Java home')
keystore_location = attribute('keystore_location',
                              value: nil,
                              description: 'Where the java keystore is located'
                             )
keystore_password = attribute('keystore_password',
                              value: 'changeit',
                              description: 'Password to the Java keystore')

control 'check-java-version' do
  impact 1.0
  title 'Verify java version'
  desc 'Verify the correct version of java is installed'

  match_java_version = "^openjdk version \"#{Regexp.escape(java_version.to_s)}[-_\"]"
  describe command('java -version 2>&1') do
    its('stdout') { should match match_java_version }
  end

  if variant == 'hotspot'
    describe command('java -version 2>&1') do
      its('stdout') { should_not match /OpenJ9/i }
    end
  else
    describe command('java -version 2>&1') do
      its('stdout') { should match /OpenJ9/i }
    end
  end
end

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
  desc 'Verify Java keystore contains the certificate'

  unless certificate_sha256_checksum.nil? || certificate_sha256_checksum.empty?
    cmd = "keytool -list -v -keystore #{keystore_location}"
    cmd.concat(" -storepass #{keystore_password}") unless keystore_password.nil?
    describe command("#{cmd} | grep SHA256:") do
      its('stdout') { should match certificate_sha256_checksum }
    end
  end
end
