# the right version of java is installed
describe command('java -version 2>&1') do
  its('stdout') { should match /1\.8/ }
end

# alternatives were properly set
describe command('alternatives --display jar') do
  its('stdout') { should match /java-1\.8\.0/ }
end

# jce is setup properly
describe command('java -jar /tmp/UnlimitedSupportJCETest.jar') do
  its('stdout') { should match /isUnlimitedSupported=TRUE/ }
  its('stdout') { should match /strength: 2147483647/ }
end
