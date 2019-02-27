adoptopenjdk_variant = attribute('adoptopenjdk_variant',
                                 default: 'openj9',
                                 description: 'Variant being used: openj9, openj9-large-heap, or hotspot'
                                )
alternative_bin_cmds = attribute('alternative_bin_cmds',
                                 default: %w(jar java keytool),
                                 description: 'List of bin commands that should be included in alternatives'
                                )
certificate_sha256_checksum = attribute('certificate_sha256_checksum',
                                        default: '64:F3:3B:A7:EF:C3:5C:6B:2D:ED:95:0B:CB:4E:96:3B:12:97:B8:62:BA:1A:8E:30:13:B0:B0:59:77:12:31:EA',
                                        description: 'The SHA256 checksum of the certificate'
                                       )
install_flavor = attribute('install_flavor',
                           default: 'adoptopenjdk',
                           description: 'The installation flavor used to install java'
                          )
java_version = attribute('java_version',
                         default: '1.8.0',
                         description: 'Which version of java should be installed'
                        )
java_home = attribute('java_home',
                      default: "/usr/lib/jvm/java-#{java_version.to_i > 8 ? java_version.to_i : java_version.split('.')[1]}-#{install_flavor}-#{adoptopenjdk_variant}",
                      description: 'Path to the Java home directory'
                     )
keystore_location = attribute('keystore_location',
                              default: nil,
                              description: 'Where the java keystore is located'
                             )
keystore_password = attribute('keystore_password',
                              default: 'changeit',
                              description: 'Password to the Java keystore'
                             )

control 'check-java-version' do
  impact 1.0
  title 'Verify java version'
  desc 'Verify the correct version of java is installed'

  match_java_version = "^openjdk version \"#{Regexp.escape(java_version.to_s)}[-_\"]"
  describe command('/usr/bin/java -version 2>&1') do
    its('stdout') { should match match_java_version }
  end

  if adoptopenjdk_variant == 'hotspot'
    describe command('/usr/bin/java -version 2>&1') do
      its('stdout') { should_not match /OpenJ9/i }
    end
  else
    describe command('/usr/bin/java -version 2>&1') do
      its('stdout') { should match /OpenJ9/i }
    end
  end
end

control 'check-java-alternatives' do
  impact 1.0
  title 'Verify alternatives for java'
  desc 'Verify alternatives for java are properly set'

  alternative_bin_cmds.each do |cmd|
    describe command("update-alternatives --display #{cmd}") do
      its('stdout') { should match "#{java_home}/bin/#{cmd}" }
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

  keystore = if keystore_location.nil? || keystore_location.empty?
               if java_version.to_i > 8
                 "#{java_home}/lib/security/cacerts"
               else
                 "#{java_home}/jre/lib/security/cacerts"
               end
             else
               keystore_location
             end

  unless certificate_sha256_checksum.nil? || certificate_sha256_checksum.empty?
    cmd = "#{java_home}/bin/keytool -list -v -keystore #{keystore}"
    cmd.concat(" -storepass #{keystore_password}") unless keystore_password.nil?
    describe command("#{cmd} | grep SHA256:") do
      its('stdout') { should match certificate_sha256_checksum }
    end
  end
end
