require 'spec_helper'

describe 'java::openjdk' do
  platforms = {
    'ubuntu' => {
      'packages' => ['openjdk-6-jdk', 'default-jre-headless'],
      'versions' => ['10.04', '12.04']
    },
    'centos' => {
      'packages' => ['java-1.6.0-openjdk', 'java-1.6.0-openjdk-devel'],
      'versions' => ['5.8', '6.3']
    }
  }

  platforms.each do |platform, data|
    data['versions'].each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) do
          ChefSpec::ChefRunner.new(:platform => platform, :version => version).converge('java::openjdk')
        end

        data['packages'].each do |pkg|
          it "installs package #{pkg}" do
            chef_run.should install_package pkg
          end

          it 'sends notifiation to update-java-alternatives' do
            chef_run.package(pkg).should notify("ruby_block[update-java-alternatives]", :create)
          end
        end
      end
    end
  end

end
