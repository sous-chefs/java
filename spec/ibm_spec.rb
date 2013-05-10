require 'spec_helper'

describe 'java::ibm' do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new
    runner.node.set['java']['install_flavor'] = 'ibm'
    runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.bin'
    runner.node.set['java']['ibm']['checksum'] = 'deadbeef'
    runner.node.set['java']['ibm']['accept_ibm_download_terms'] = true
    runner.converge('java::ibm')
  end

  it 'creates an installer.properties file' do
    chef_run.should create_file '/var/chef/cache/installer.properties'
  end

  it 'downloads the remote jdk file' do
    chef_run.should create_remote_file '/var/chef/cache/ibm-java.bin'
  end

  it 'runs the installer' do
    chef_run.should execute_command "./ibm-java.bin -f ./installer.properties -i silent"
  end

  it 'includes the set_java_home recipe' do
    chef_run.should include_recipe 'java::set_java_home'
  end
end
