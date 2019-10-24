# the right version of java is installed
describe command('java -version 2>&1') do
  its('stdout') { should match /openjdk version \"11\.\d+\.\d+\"/ }
end

# alternatives were properly set
# disable this until we come up with a cross platform test
# describe command('update-alternatives --display jar') do
#   its('stdout') { should match /\/usr\/lib\/jvm\/java-8-oracle-amd64\/bin\/jar/ }
# end

unless os.bsd?
  # alternatives were properly set
  describe command('update-alternatives --display jar') do
    its('stdout') { should match %r{\/usr\/lib\/jvm\/java-11} } # https://rubular.com/r/H7J6J3q9GhJJ5A
  end
end
