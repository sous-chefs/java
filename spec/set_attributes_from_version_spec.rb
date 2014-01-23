require 'spec_helper'

describe 'java::set_attributes_from_version' do
  platforms = {
    'rhel' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel']
    },
    'fedora' => {
      'java_home' => '/usr/lib/jvm/java-1.6.0',
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel']
    },
    'freebsd' => {
      'java_home' => "/usr/local/openjdk6",
      'packages' => ["openjdk6"]
    },
    'arch' => {
      'java_home' => "/usr/lib/jvm/java-6-openjdk",
      'packages' => ["openjdk6"]
    },
    'debian' => {
      'java_home' => '/usr/lib/jvm/java-6-openjdk',
      'packages' => ['openjdk-6-jdk', 'openjdk-6-jre-headless']
    },
    'smartos' => {
      'java_home' => '/opt/local/java/sun6',
      'packages' => ['sun-jdk6', 'sun-jre6']
    },
    'windows' => {
      'java_home' => nil,
      'packages' => []
    },
    'foo' => {
      'java_home' => "/usr/lib/jvm/default-java",
      'packages' => ["openjdk-6-jdk"]
    }
  }

  platforms.each do |platform, params|
    context "#{platform}" do
      let(:chef_run) do
        runner = ChefSpec::Runner.new
        runner.node.set['platform_family'] = platform
        runner.converge(described_recipe)
      end

      it 'has the correct java_home' do
        expect(chef_run.node['java']['java_home']).to eq(params['java_home'])
      end

      it 'has the correct openjdk_packages' do
        expect(chef_run.node['java']['openjdk_packages']).to eq(params['packages'])
      end
    end
  end
end
