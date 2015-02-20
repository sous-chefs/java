require 'spec_helper'

describe 'java::default' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(
      :platform => 'debian',
      :version => '7.0'
    )
    runner.converge(described_recipe)
  end
  it 'should include the openjdk recipe by default' do
    expect(chef_run).to include_recipe('java::openjdk')
  end
  it 'includes set_attributes_from_version' do
    expect(chef_run).to include_recipe('java::set_attributes_from_version')
  end

  context 'windows' do
     let(:chef_run) do
       runner = ChefSpec::ServerRunner.new(
         :platform => 'windows',
         :version => '2008R2'
       )
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
       allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('java::windows')
       runner.node.set['java']['install_flavor'] = 'not_windows'
       runner.converge(described_recipe)
     end

     it 'writes a log when install_flavor is set to windows' do
       expect(chef_run).to write_log("Setting node['java']['install_flavor'] = 'windows'")
     end

     it 'should include the windows recipe' do
       expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('java::windows')
       chef_run
     end
  end

  context 'oracle' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'oracle'
      runner.converge(described_recipe)
    end

    it 'should include the oracle recipe' do
      expect(chef_run).to include_recipe('java::oracle')
    end
  end

  context 'oracle_i386' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'oracle_i386'
      runner.converge(described_recipe)
    end

    it 'should include the oracle_i386 recipe' do
      expect(chef_run).to include_recipe('java::oracle_i386')
    end
  end

  context 'ibm' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'ibm'
      runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.bin'
      runner.converge(described_recipe)
    end

    it 'should include the ibm recipe' do
      expect(chef_run).to include_recipe('java::ibm')
    end
  end

  context 'ibm_tar' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'ibm_tar'
      runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.tar.gz'
      runner.converge(described_recipe)
    end

    it 'should include the ibm_tar recipe' do
      expect(chef_run).to include_recipe('java::ibm_tar')
    end
  end

  context 'Oracle JDK 8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'oracle'
      runner.node.set['java']['jdk_version'] = '8'
      runner.converge(described_recipe)
    end

    it 'should not error' do
      expect{chef_run}.to_not raise_error
    end
  end

  context 'OpenJDK 8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.set['java']['install_flavor'] = 'openjdk'
      runner.node.set['java']['jdk_version'] = '8'
      runner.converge(described_recipe)
    end

    it 'should error' do
      expect{chef_run}.to raise_error
    end
  end
end
