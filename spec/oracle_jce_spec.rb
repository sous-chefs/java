require 'spec_helper'

describe 'java::oracle_jce' do
  context 'Jar installation on Windows systems' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.override['java']['java_home'] = 'c:/jdk1.8'
        node.override['java']['jdk_version'] = '8'
        node.override['java']['oracle']['jce']['home'] = 'c:/temp/jce'
      end
      runner.converge(described_recipe)
    end
    let(:zipfile) { chef_run.windows_zipfile('c:/temp/jce/8') }

    before do
      allow(::File).to receive(:read).and_call_original
      allow(::File).to receive(:read).with('c:/temp/jce/8/UnlimitedJCEPolicy8/local_policy.jar')
        .and_return('local_policy.jar contents')
      allow(::File).to receive(:read).with('c:/temp/jce/8/UnlimitedJCEPolicy8/US_export_policy.jar')
        .and_return('US_export_policy.jar contents')
    end

    it 'creates JCE zip file staging path' do
      expect(chef_run).to create_directory('c:/temp/jce/8')
    end

    it 'extracts JCE zip to staging path' do
      expect(chef_run).to unzip_windows_zipfile_to('c:/temp/jce/8')
    end

    it 'creates local_policy.jar file resource' do
      expect(chef_run).to create_remote_file('c:/jdk1.8/jre/lib/security/local_policy.jar')
    end

    it 'creates US_export_policy.jar file resource' do
      expect(chef_run).to create_remote_file('c:/jdk1.8/jre/lib/security/US_export_policy.jar')
    end
  end

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
