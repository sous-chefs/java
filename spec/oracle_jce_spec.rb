require 'spec_helper'

describe 'java::oracle_jce' do
  context 'Jar installation on POSIX systems' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.override['java']['java_home'] = '/usr/lib/jvm/java'
      end
      runner.converge(described_recipe)
    end

    let(:file_cache_path) { Chef::Config[:file_cache_path] }

    it 'creates JCE home' do
      expect(chef_run).to create_directory('/opt/java_jce/6')
    end

    it 'downloads the JCE zip' do
      expect(chef_run).to create_remote_file("#{file_cache_path}/jce.zip")
    end

    it 'Installs dependencies' do
      expect(chef_run).to install_package('unzip')
      expect(chef_run).to install_package('curl')
    end

    it 'Deletes old jar file' do
      expect(chef_run).to delete_file('/usr/lib/jvm/java/jre/lib/security/local_policy.jar')
      expect(chef_run).to delete_file('/usr/lib/jvm/java/jre/lib/security/US_export_policy.jar')
    end

    it 'Links jars' do
      expect(chef_run).to create_link('/usr/lib/jvm/java/jre/lib/security/local_policy.jar').with(to: '/opt/java_jce/6/local_policy.jar')
      expect(chef_run).to create_link('/usr/lib/jvm/java/jre/lib/security/US_export_policy.jar').with(to: '/opt/java_jce/6/US_export_policy.jar')
    end
  end
end
