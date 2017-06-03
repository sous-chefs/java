describe command('java -version') do
  its('stdout') { should include 'IBM' }
end
