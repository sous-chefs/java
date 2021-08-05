variant = input('variant', value: 'openj9', description: 'Variant being used: openj9, openj9-large-heap, or hotspot')
alternative_bin_cmds = input('alternative_bin_cmds',
                                 value: %w(jar java keytool),
                                 description: 'List of bin commands that should be included in alternatives')
java_version = input('java_version',
                         value: '1.8.0',
                         description: 'Which version of java should be installed')
java_home = input('java_home',
                      value: "/usr/lib/jvm/java-#{java_version.to_i > 8 ? java_version.to_i : java_version.split('.')[1]}-adoptopenjdk-#{variant}",
                      description: 'Path to the Java home directory')

control 'check-removal-java-directory' do
  impact 1.0
  title 'Verify java directory has been removed'
  desc 'Verify java directory has been removed'

  describe directory(java_home) do
    it { should_not exist }
  end
end

control 'check-java-alternatives-removal' do
  impact 1.0
  title 'Verify alternatives for java are removed'
  desc 'Verify alternatives for java are removed'

  # NOTE: platform_family?('rhel') is not working for amazon-linux
  if os.family == 'redhat'
    alternative_bin_cmds.each do |cmd|
      describe command("update-alternatives --display #{cmd}") do
        its('stdout') { should_not match "#{java_home}/bin/#{cmd}" }
      end
    end
  end
end
