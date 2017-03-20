require 'spec_helper'

describe 'java::ibm_tar' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
    runner.node.override['java']['java_home'] = '/home/java'
    runner.node.override['java']['install_flavor'] = 'ibm'
    runner.node.override['java']['ibm']['url'] = 'http://example.com/ibm-java.tar.gz'
    runner.node.override['java']['ibm']['checksum'] = 'deadbeef'
    runner.converge(described_recipe)
  end

  let(:install_ibm_java) { chef_run.execute('install-ibm-java') }

  it 'should include the notify recipe' do
    expect(chef_run).to include_recipe('java::notify')
  end

  it 'downloads the remote jdk file' do
    expect(chef_run).to create_remote_file(Chef::Config[:file_cache_path] + '/ibm-java.tar.gz')
  end

  it 'create java_home directory' do
    expect(chef_run).to create_directory('/home/java')
  end

  it 'untar the jdk file' do
    expect(chef_run).to run_execute('untar-ibm-java').with(
      command: 'tar xzf ./ibm-java.tar.gz -C /home/java --strip 1',
      creates: '/home/java/jre/bin/java'
    )

    untar_command = chef_run.execute('untar-ibm-java')
    expect(untar_command).to notify('java_alternatives[set-java-alternatives]')
  end

  it 'should notify of jdk-version-change' do
    expect(chef_run.execute('untar-ibm-java')).to notify('log[jdk-version-changed]')
  end

  it 'includes the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end
end
