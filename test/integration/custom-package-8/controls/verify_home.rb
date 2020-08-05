control 'Custom URL JAVA_HOME' do
  impact 1.0
  title 'Installed'
  desc 'Custom URL install sets JAVA_HOME properly'

  describe command('java -version 2>&1') do
    its('stdout') { should match 'openjdk version "1.8.0_232"' }
  end

  describe directory('/usr/lib/jvm/java-8-adoptopenjdk-hotspot/jdk8u232-b09') do
    it { should exist }
  end

  describe file('/etc/profile.d/java.sh') do
    its('content') { should match 'JAVA_HOME=/usr/lib/jvm/java-8-adoptopenjdk-hotspot/jdk8u232-b09' }
  end
end
