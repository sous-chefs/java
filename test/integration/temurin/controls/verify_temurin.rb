java_version = input('java_version', description: 'Which version of java should be installed')

control 'Temurin Java is installed & linked correctly' do
  impact 1.0
  title 'Installed'
  desc 'Temurin Java is installed & linked correctly'

  describe command('java -version 2>&1') do
    its('stdout') { should match(java_version.to_s) }
    its('stdout') { should match(/Temurin/) }
  end
end

control 'Temurin Java path is correct' do
  impact 1.0
  title 'Path Verification'
  desc 'Verifies that keytool and other binaries are accessible in the correct paths using update-alternatives'

  # Handle architecture-specific paths
  describe command('update-alternatives --display jar') do
    its('stdout') { should match %r{/usr/lib/jvm/temurin-#{java_version}-jdk(-[a-z0-9]+)?/bin/jar} }
  end

  describe command('update-alternatives --display java') do
    its('stdout') { should match %r{/usr/lib/jvm/temurin-#{java_version}-jdk(-[a-z0-9]+)?/bin/java} }
  end

  describe command('update-alternatives --display keytool') do
    # Check for architecture-specific paths with regex that allows for optional architecture suffix
    its('stdout') { should match %r{/usr/lib/jvm/temurin-#{java_version}-jdk(-[a-z0-9]+)?/bin/keytool} }
    its('stdout') { should match(/priority/) }
  end
end

control 'Adoptium repository is properly configured' do
  impact 1.0
  title 'Repository Configuration'
  desc 'Verifies that the Adoptium repository is properly configured'

  # Handle platform detection more robustly
  if os.family == 'debian'
    describe file('/etc/apt/sources.list.d/adoptium.list') do
      it { should exist }
      its('content') { should match(/packages.adoptium.net/) }
    end
  elsif os.family == 'redhat' || os.family == 'fedora' || os.name == 'amazon'
    describe file('/etc/yum.repos.d/adoptium.repo') do
      it { should exist }
      its('content') { should match(/packages.adoptium.net/) }
    end
  elsif os.family == 'suse'
    describe file('/etc/zypp/repos.d/adoptium.repo') do
      it { should exist }
      its('content') { should match(/packages.adoptium.net/) }
    end
  end
end
