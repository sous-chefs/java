describe command('java -version') do
  its('stdout') { should match /IBM/ }
end
