require 'spec_helper'

describe 'java::oracle_i386' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new
    runner.converge(described_recipe)
  end

  it 'should include the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  it 'should include the notify recipe' do
    expect(chef_run).to include_recipe('java::notify')
  end

  it 'should notify of jdk-version-change' do
    pending 'Testing LWRP use is not required at this time, this is tested post-converge.'
    expect(chef_run.jdk_ark('jdk-alt')).to notify('log[jdk-version-changed]')
    this_should_not_get_executed
  end

  it 'should configure a java_ark[jdk] resource' do
    pending 'Testing LWRP use is not required at this time, this is tested post-converge.'
    this_should_not_get_executed
  end

  describe 'conditionally includes set attributes' do
    context 'when java_home is set' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        )
        runner.node.override['java']['java_home'] = '/some/path'
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to_not include_recipe('java::set_attributes_from_version')
      end
    end

    context 'when java_home is not set' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(
          platform: 'ubuntu',
          version: '12.04'
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
        ChefSpec::ServerRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ).converge(described_recipe)
      end

      it 'includes default_java_symlink' do
        expect(chef_run).to include_recipe('java::default_java_symlink')
      end
    end

    context 'centos' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(
          platform: 'centos',
          version: '6.8'
        ).converge(described_recipe)
      end

      it 'does not include default_java_symlink' do
        expect(chef_run).to_not include_recipe('java::default_java_symlink')
      end
    end
  end

  describe 'JCE installation' do
    context 'when jce is disabled' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new.converge(described_recipe)
      end

      it 'does not include jce recipe' do
        expect(chef_run).to_not include_recipe('java::oracle_jce')
      end
    end

    context 'when jce is enabled' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new do |node|
          node.override['java']['oracle']['jce']['enabled'] = true
        end.converge(described_recipe)
      end

      it 'does include jce recipe' do
        expect(chef_run).to include_recipe('java::oracle_jce')
      end
    end
  end
end
