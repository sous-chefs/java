control 'Custom URL JAVA_HOME' do
  impact 1.0
  title 'Installed'
  desc 'Custom URL install sets JAVA_HOME properly'

  describe command('java -version 2>&1') do
    its('stdout') { should match 'openjdk version "11.0.7"' }
  end

  describe directory('/usr/lib/jvm/java-11-adoptopenjdk-hotspot/') do
    it { should exist }
  end

  describe file('/etc/profile.d/java.sh') do
    its('content') { should match 'JAVA_HOME=/usr/lib/jvm/java-11-adoptopenjdk-hotspot/jdk-11.0.7\+10' }
  end
end
