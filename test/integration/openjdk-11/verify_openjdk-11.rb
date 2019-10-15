# the right version of java is installed
describe command('java -version 2>&1') do
  its('stdout') { should match /11\.0\.1/ }
end

unless os.bsd?
  # alternatives were properly set
  describe command('update-alternatives --display jar') do
    its('stdout') { should match %r{\/usr\/lib\/jvm\/java-11} } # https://rubular.com/r/H7J6J3q9GhJJ5A
  end
end
