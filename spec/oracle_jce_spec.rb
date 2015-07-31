require 'spec_helper'

describe 'java::oracle_jce' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new
    runner.converge(described_recipe)
  end

  it 'downloads the JCE zip' do
    expect(chef_run).to run_execute('download jce')
  end
  it 'extracts JCE zip' do
    expect(chef_run).to run_execute('extract jce')
  end

  it 'Installs dependencies' do
    expect(chef_run).to install_package('unzip')
    expect(chef_run).to install_package('curl')
  end

  context 'Jar installation' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new do |node|
        node.set['java']['java_home'] = '/usr/lib/jvm/java'
      end
      runner.converge(described_recipe)
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
