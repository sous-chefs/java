# the right version of java is installed
describe command('java -version') do
  its('stdout') { should match /1\.8\.0/ }
end

# enables JAVA_HOME to be properly set with the java_home util
describe command("/usr/libexec/java_home -v '1.8*'") do
  its('stdout') { should match /1\.8\.0_/ }
end

# does not installs JCE
describe command('java -jar /tmp/UnlimitedSupportJCETest.jar') do
  its('stdout') { should eq 'isUnlimitedSupported=FALSE, strength: 128' }
end
