require 'spec_helper'

describe 'java::default' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(
      platform: 'debian',
      version: '7.11'
    )
    runner.converge(described_recipe)
  end
  it 'should include the oracle recipe by default' do
    expect(chef_run).to include_recipe('java::oracle')
  end
  it 'includes set_attributes_from_version' do
    expect(chef_run).to include_recipe('java::set_attributes_from_version')
  end

  context 'oracle' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['java']['install_flavor'] = 'oracle'
      runner.converge(described_recipe)
    end

    it 'should include the oracle recipe' do
      expect(chef_run).to include_recipe('java::oracle')
    end
  end

  context 'Oracle JDK 8' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.node.override['java']['install_flavor'] = 'oracle'
      runner.node.override['java']['jdk_version'] = '8'
      runner.converge(described_recipe)
    end

    it 'should not error' do
      expect { chef_run }.to_not raise_error
    end
  end
end
