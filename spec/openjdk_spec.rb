require 'spec_helper'

describe 'java::openjdk' do
  platforms = {
    'ubuntu-12.04' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true,
    },
    'debian-7.11' => {
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
      'update_alts' => true,
    },
    'centos-6.8' => {
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
      'update_alts' => true,
    },
    'smartos-joyent_20130111T180733Z' => {
      'packages' => ['sun-jdk6', 'sun-jre6'],
      'update_alts' => false,
    },
  }

  platforms.each do |platform, data|
    parts = platform.split('-')
    os = parts[0]
    version = parts[1]
    context "On #{os} #{version}" do
      let(:chef_run) { ChefSpec::ServerRunner.new(platform: os, version: version).converge(described_recipe) }

      data['packages'].each do |pkg|
        it "installs package #{pkg}" do
          expect(chef_run).to install_package(pkg)
          expect(chef_run.package(pkg)).to notify('log[jdk-version-changed]')
        end
      end

      it 'should include the notify recipe' do
        expect(chef_run).to include_recipe('java::notify')
      end

      it 'sends notification to update-java-alternatives' do
        if data['update_alts']
          expect(chef_run).to set_java_alternatives('set-java-alternatives')
        else
          expect(chef_run).to_not set_java_alternatives('set-java-alternatives')
        end
      end
    end
  end

  describe 'conditionally includes set attributes' do
    context 'when java_home and openjdk_packages are set' do
      let(:chef_run) do
        runner = ChefSpec::ServerRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        )
        runner.node.override['java']['java_home'] = '/some/path'
        runner.node.override['java']['openjdk_packages'] = %w(dummy stump)
        runner.converge(described_recipe)
      end

      it 'does not include set_attributes_from_version' do
        expect(chef_run).to_not include_recipe('java::set_attributes_from_version')
      end
    end

    context 'when java_home and openjdk_packages are not set' do
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

  describe 'license acceptance file' do
    { 'centos' => '6.8', 'ubuntu' => '12.04' }.each_pair do |platform, version|
      context platform do
        let(:chef_run) do
          ChefSpec::ServerRunner.new(platform: platform, version: version).converge('java::openjdk')
        end

        it 'does not write out license file' do
          expect(chef_run).not_to create_file('/opt/local/.dlj_license_accepted')
        end
      end
    end

    context 'smartos' do
      let(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'smartos', version: 'joyent_20130111T180733Z', evaluate_guards: true)
      end

      context 'when auto_accept_license is true' do
        it 'writes out a license acceptance file' do
          chef_run.node.override['java']['accept_license_agreement'] = true
          expect(chef_run.converge(described_recipe)).to create_file('/opt/local/.dlj_license_accepted')
        end
      end

      context 'when auto_accept_license is false' do
        it 'does not write license file' do
          chef_run.node.override['java']['accept_license_agreement'] = false
          expect(chef_run.converge(described_recipe)).not_to create_file('/opt/local/.dlj_license_accepted')
        end
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
end
