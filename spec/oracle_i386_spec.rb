require 'spec_helper'

describe 'java::oracle_i386' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.converge(described_recipe)
  end

  it 'should include the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  it 'should configure a java_ark[jdk] resource' do
    pending "Testing LWRP use is not required at this time, this is tested post-converge."
  end

  describe 'conditionally includes set attributes' do
    context 'when java_home is set' do
      let(:chef_run) do
        runner = ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        )
        runner.node.set['java']['java_home'] = "/some/path"
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to_not include_recipe('java::set_attributes_from_version')
      end
    end

    context 'when java_home is not set' do
      let(:chef_run) do
        runner = ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        )
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to include_recipe('java::set_attributes_from_version')
      end
    end
  end

  describe 'default-java' do
    context 'ubuntu' do
      let(:chef_run) do
        ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        ).converge(described_recipe)
      end

      it 'includes default_java_symlink' do
        expect(chef_run).to include_recipe('java::default_java_symlink')
      end
    end

    context 'centos' do
      let(:chef_run) do
        ChefSpec::Runner.new(
          :platform => 'centos',
          :version => '6.4'
        ).converge(described_recipe)
      end

      it 'does not include default_java_symlink' do
        expect(chef_run).to_not include_recipe('java::default_java_symlink')
      end
    end
  end
end
