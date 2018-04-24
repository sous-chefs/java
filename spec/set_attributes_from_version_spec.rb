require 'spec_helper'

describe 'java::set_attributes_from_version' do
  platforms = {
    'centos-6.9' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'redhat-6.9' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'freebsd-10.3' => {
      'java_home' => '/usr/local/openjdk6',
      'packages' => ['openjdk6'],
    },
    'debian-7.11' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'ubuntu-14.04' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'windows-2008R2' => {
      'java_home' => nil,
      'packages' => [],
    },
  }

  platforms.each do |platform, params|
    parts = platform.split('-')
    os = parts[0]
    version = parts[1]
    context "On #{os} #{version}" do
      let(:chef_run) { ChefSpec::SoloRunner.new(version: version, platform: os).converge(described_recipe) }

      it 'has the correct java_home' do
        expect(chef_run.node['java']['java_home']).to eq(params['java_home'])
      end

      it 'has the correct openjdk_packages' do
        expect(chef_run.node['java']['openjdk_packages']).to eq(params['packages'])
      end
    end
  end
end
