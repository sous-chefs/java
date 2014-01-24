require 'spec_helper'

describe 'java::default' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(
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
      runner = ChefSpec::Runner.new(
        :platform => 'windows',
        :version => '2008R2'
      )
      runner.node.set['java']['windows']['url'] = 'http://example.com/windows-java.msi'
      runner.node.set['java']['java_home'] = 'C:/java'
      runner.converge('windows::default',described_recipe)
    end

    # Running the tests on non-Windows platforms will error in the Windows library,
    # but this means the recipe was included. There has to be a better way to handle this...
    it 'should error on windows recipe' do
      expect { chef_run }.to raise_error(TypeError)
    end
  end

  context 'oracle' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.set['java']['install_flavor'] = 'oracle'
      runner.converge(described_recipe)
    end

    it 'should include the oracle recipe' do
      expect(chef_run).to include_recipe('java::oracle')
    end
  end

  context 'oracle_i386' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.set['java']['install_flavor'] = 'oracle_i386'
      runner.converge(described_recipe)
    end

    it 'should include the oracle_i386 recipe' do
      expect(chef_run).to include_recipe('java::oracle_i386')
    end
  end

  context 'ibm' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
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
      runner = ChefSpec::Runner.new
      runner.node.set['java']['install_flavor'] = 'ibm_tar'
      runner.node.set['java']['ibm']['url'] = 'http://example.com/ibm-java.tar.gz'
      runner.converge(described_recipe)
    end

    it 'should include the ibm_tar recipe' do
      expect(chef_run).to include_recipe('java::ibm_tar')
    end
  end

end
