java_version = input('java_version', description: 'Which version of java should be installed')

control 'Java is installed & linked correctly' do
  impact 1.0
  title 'Installed'
  desc 'Java is installed & linked correctly'
  describe command('java -version 2>&1') do
    its('stdout') { should match java_version.to_s }
  end
end

control 'Java path is correct' do
  impact 1.0
  title 'Path Verification'
  desc 'Verifies that keytool and other binaries are accessible in the correct paths using update-alternatives'

  # Get architecture suffix
  arch_suffix = command('uname -m').stdout.strip == 'x86_64' ? 'amd64' : 'arm64'

  describe command('update-alternatives --display jar') do
    its('stdout') { should match %r{/usr/lib/jvm/java} }
  end

  describe command('update-alternatives --display java') do
    its('stdout') { should match %r{/usr/lib/jvm/java-#{java_version}-openjdk-#{arch_suffix}/bin/java} }
  end

  describe command('update-alternatives --display keytool') do
    its('stdout') { should match %r{link best version is /usr/lib/jvm/java-#{java_version}-openjdk-#{arch_suffix}/bin/keytool} }
    its('stdout') { should match %r{link keytool is /usr/bin/keytool} }
    its('stdout') { should match /priority 1/ }
  end
end
