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

  # Regression test for COOK-2989
  context 'update-java-alternatives' do
    let(:chef_run) do
      ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04').converge('java::openjdk')
    end

    it 'executes update-java-alternatives with the right commands' do
      # We can't use a regexp in the matcher's #with attributes, so
      # let's reproduce the code block with the heredoc + gsub:
      code_string = <<-EOH.gsub(/^\s+/, '')
      update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java 1061 && \
      update-alternatives --set java /usr/lib/jvm/java-6-openjdk-amd64/jre/bin/java
      EOH
      expect(chef_run).to execute_bash_script('update-java-alternatives').with(:code => code_string)
    end
  end

  platforms.each do |platform, data|
    data['versions'].each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) do
          ChefSpec::ChefRunner.new(:platform => platform, :version => version).converge('java::openjdk')
        end

        data['packages'].each do |pkg|
          it "installs package #{pkg}" do
            expect(chef_run).to install_package(pkg)
          end

          it 'sends notifiation to update-java-alternatives' do
            expect(chef_run.package(pkg)).to notify("bash[update-java-alternatives]", :run)
          end
        end
      end
    end
  end

end
