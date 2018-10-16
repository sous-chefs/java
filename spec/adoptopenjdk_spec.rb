require 'spec_helper'

describe 'java::adoptopenjdk' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new
    runner.node.override['java']['jdk_version'] = '11'
    runner.node.override['java']['install_flavor'] = 'adoptopenjdk'
    runner.converge('java::default')
  end

  it 'should include the notify recipe' do
    expect(chef_run).to include_recipe('java::notify')
  end

  it 'should include the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  it 'should configure a adoptopenjdk_install[adoptopenjdk] resource' do
    pending 'Testing LWRP use is not required at this time, this is tested post-converge.'
    this_should_not_get_executed
  end

  it 'should notify jdk-version-change' do
    expect(chef_run.adoptopenjdk_install('adoptopenjdk')).to notify('log[jdk-version-changed]')\
      .to(:write).immediately
  end

  describe 'default-java' do
    context 'ubuntu' do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: 'ubuntu',
                                          version: '18.04')
        runner.node.override['java']['jdk_version'] = '11'
        runner.node.override['java']['install_flavor'] = 'adoptopenjdk'
        runner.converge('java::default')
      end

      it 'includes default_java_symlink' do
        expect(chef_run).to include_recipe('java::default_java_symlink')
      end
    end

    context 'centos' do
      let(:chef_run) do
        runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.5')
        runner.node.override['java']['jdk_version'] = '11'
        runner.node.override['java']['install_flavor'] = 'adoptopenjdk'
        runner.converge('java::default')
      end

      it 'does not include default_java_symlink' do
        expect(chef_run).to_not include_recipe('java::default_java_symlink')
      end
    end
  end
end
