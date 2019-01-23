require 'spec_helper'

describe 'java::set_attributes_from_version' do
  platforms = {
    'centos-6.9' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'jdk_version' => '6',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'centos-7.6.1804' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'jdk_version' => '6',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'redhat-6.9' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'jdk_version' => '6',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'freebsd-10.3' => {
      'java_home' => '/usr/local/openjdk6',
      'jdk_version' => '6',
      'packages' => ['openjdk6'],
    },
    'debian-7.11' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'jdk_version' => '6',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'ubuntu-14.04' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'jdk_version' => '6',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'windows-2008R2' => {
      'java_home' => nil,
      'jdk_version' => '6',
      'packages' => [],
    },
    'mac_os_x-10.12' => {
      'java_home' => '$(/usr/libexec/java_home -v 1.6)',
      'jdk_version' => '6',
      'packages' => [],
    },
    'mac_os_x-10.14' => {
      'java_home' => '$(/usr/libexec/java_home -v 11)',
      'jdk_version' => '11',
      'packages' => [],
    },
  }

  platforms.each do |platform, params|
    parts = platform.split('-')
    os = parts[0]
    os_version = parts[1]
    jdk_version = params['jdk_version']
    context "On #{os} #{os_version} with jdk version #{jdk_version}" do
      let(:chef_run) { ChefSpec::SoloRunner.new(version: os_version, platform: os) }

      it 'has the correct java_home' do
        chef_run.node.override['java']['jdk_version'] = jdk_version
        chef_run.converge(described_recipe)
        expect(chef_run.node['java']['java_home']).to eq(params['java_home'])
      end

      it 'has the correct openjdk_packages' do
        chef_run.node.default['java']['jdk_version'] = jdk_version
        chef_run.converge(described_recipe)
        expect(chef_run.node['java']['openjdk_packages']).to eq(params['packages'])
      end
    end
  end
end
