variant = input('variant', description: 'Variant being used: openj9, openj9-large-heap, or hotspot')
java_version = input('java_version', description: 'Which version of java should be installed')
parent_install_dir = input('parent_install_dir',
                     value: "java-#{java_version.to_i > 8 ? java_version.to_i : java_version.split('.')[1]}-adoptopenjdk-#{variant}",
                     description: 'The parent of the Java home')
java_home_dir = input('java_home_dir', description: 'Name of the JAVA_HOME directory')

control 'check-java-version' do
  impact 1.0
  title 'Verify java version'
  desc 'Verify the correct version of java is installed'

  describe command('java -version 2>&1') do
    its('stdout') { should match /AdoptOpenJDK/ } unless java_version.to_i == 1
    its('stdout') { should match Regexp.new(java_version.to_s) }
  end
end

control 'check-java-home' do
  impact 1.0
  title 'Check JAVA_HOME is set'
  desc 'Check that custom URL install sets JAVA_HOME properly'

  describe directory("/usr/lib/jvm/#{parent_install_dir}/#{java_home_dir}") do
    it { should exist }
  end

  describe file('/etc/profile.d/java.sh') do
    its('content') { should eq "export JAVA_HOME=/usr/lib/jvm/#{parent_install_dir}/#{java_home_dir}\n" }
  end
end
