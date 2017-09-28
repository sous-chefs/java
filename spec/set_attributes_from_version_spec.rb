require 'spec_helper'

describe 'java::set_attributes_from_version' do
  platforms = {
    'centos-6.4' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'redhat-6.3' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
    },
    'freebsd-9.3' => {
      'java_home' => '/usr/local/openjdk6',
      'packages' => ['openjdk6'],
    },
    'debian-7.11' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'ubuntu-12.04' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk-amd64',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless'],
    },
    'smartos-joyent_20130111T180733Z' => {
      'java_home' => '/opt/local/java/sun6',
      'packages' => ['sun-jdk6', 'sun-jre6'],
    },
    'opensuse-42.3' => {
      'java_home' => '/usr/lib64/jvm/jre-1.6.0-openjdk',
      'packages' => ['java-1_6_0-openjdk', 'java-1_6_0-openjdk-headless'],
    },
    'windows-2008R2' => {
      'java_home' => nil,
      'packages' => [],
    },
  }

  platforms.each do |platform, params|
    os, version = platform.split('-')
    context "On #{os} #{version}" do
      let(:chef_run) { ChefSpec::ServerRunner.new(version: version, platform: os).converge(described_recipe) }

      it 'has the correct java_home' do
        expect(chef_run.node['java']['java_home']).to eq(params['java_home'])
      end

      it 'has the correct openjdk_packages' do
        expect(chef_run.node['java']['openjdk_packages']).to eq(params['packages'])
      end
    end
  end
end
