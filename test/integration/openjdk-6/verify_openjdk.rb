# the right version of java is installed
describe command('java -version 2>&1') do
  its('stdout') { should match /1\.6\.0/ }
end

unless os.bsd?
  # alternatives were properly set
  describe command('update-alternatives --display jar') do
    its('stdout') { should match %r{\/usr\/lib\/jvm\/java-[1.]*6} } # http://rubular.com/r/IhaUzfbHoC
  end
end

# jce is setup properly
describe command('java -jar /tmp/UnlimitedSupportJCETest.jar') do
  its('stdout') { should match /isUnlimitedSupported=TRUE, strength: 2147483647/ }
end
