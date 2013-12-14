require 'spec_helper'

describe 'java::ibm_tar' do
  let(:chef_run) do
    runner = ChefSpec::ChefRunner.new
    runner.node.set['java']['java_home'] = '/home/java'
    runner.node.set['java']['install_flavor'] = 'ibm'
    runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.tar.gz'
    runner.node.set['java']['ibm']['checksum'] = 'deadbeef'
    runner.converge('java::ibm_tar')
  end

  it 'downloads the remote jdk file' do
    expect(chef_run).to create_remote_file('/var/chef/cache/ibm-java.tar.gz')
  end

  it 'create java_home directory' do
    expect(chef_run).to create_directory('/home/java')
  end

  it 'untar the jdk file' do
    expect(chef_run).to execute_command('tar xzf ./ibm-java.tar.gz -C /home/java --strip 1')
  end

  it 'includes the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end
end
