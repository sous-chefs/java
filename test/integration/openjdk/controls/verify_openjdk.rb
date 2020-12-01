java_version = input('java_version', description: 'Which version of java should be installed')

control 'Java is installed & linked correctly' do
  impact 1.0
  title 'Installed'
  desc 'Java is installed & linked correctly'
  describe command('java -version 2>&1') do
    its('stdout') { should match java_version.to_s }
  end

  describe command('update-alternatives --display jar') do
    # the openjdk 11 package on amazon linux 2 creates a symbolic link
    # using jre-<version> rather than java-<version> like the other platforms.
    if os[:name] == 'amazon' && os[:release].start_with?('2') && java_version.to_i == 11
      its('stdout') { should match %r{\/usr\/lib\/jvm\/jre} }
    else
      its('stdout') { should match %r{\/usr\/lib\/jvm\/java} }
    end
  end
end
