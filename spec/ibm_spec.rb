require 'spec_helper'

describe 'java::ibm' do
  before do
    Chef::Config[:file_cache_path] = '/var/chef/cache'
  end

  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.node.set['java']['install_flavor'] = 'ibm'
    runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.bin'
    runner.node.set['java']['ibm']['checksum'] = 'deadbeef'
    runner.node.set['java']['ibm']['accept_ibm_download_terms'] = true
    runner.converge(described_recipe)
  end

  it 'creates an installer.properties file' do
    expect(chef_run).to create_template('/var/chef/cache/installer.properties')
  end

  it 'downloads the remote jdk file' do
    expect(chef_run).to create_remote_file('/var/chef/cache/ibm-java.bin')
  end

  it 'runs the installer' do
    expect(chef_run).to run_execute('install-ibm-java').with(
      :command => './ibm-java.bin -f ./installer.properties -i silent',
      :creates => '/opt/ibm/java/jre/bin/java'
    )

    install_command = chef_run.execute('install-ibm-java')
    expect(install_command).to notify('java_alternatives[set-java-alternatives]')
  end

  it 'includes the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  context 'install on ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new(:platform => 'ubuntu', :version => '12.04')
      runner.node.set['java']['install_flavor'] = 'ibm'
      runner.node.set['java']['ibm']['checksum'] = 'deadbeef'
      runner.node.set['java']['ibm']['accept_ibm_download_terms'] = true
      runner
    end

    it 'install rpm for installable package' do
      chef_run.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.bin'
      chef_run.converge('java::ibm')
      expect(chef_run).to install_package('rpm')
    end

    it 'no need to install rpm for tgz package' do
      chef_run.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java-archive.bin'
      chef_run.converge('java::ibm')
      expect(chef_run).not_to install_package('rpm')
    end
  end

  context 'install on centos' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new(:platform => 'centos', :version => '5.8')
      runner.node.set['java']['install_flavor'] = 'ibm'
      runner.node.set['java']['ibm']['checksum'] = 'deadbeef'
      runner.node.set['java']['ibm']['accept_ibm_download_terms'] = true
      runner
    end

    it 'no need to install rpm for installable package' do
      chef_run.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.bin'
      chef_run.converge('java::ibm')
      expect(chef_run).not_to install_package('rpm')
    end

    it 'no need to install rpm for tgz package' do
      chef_run.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java-archive.bin'
      chef_run.converge('java::ibm')
      expect(chef_run).not_to install_package('rpm')
    end
  end

end
