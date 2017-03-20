require 'chefspec'

describe 'java::windows' do
  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new(
      platform: 'windows',
      version: '2012R2'
    )
    runner.node.override['java']['windows']['url'] = 'http://example.com/windows-java.msi'
    runner.node.override['java']['windows']['package_name'] = 'windows-java'
    runner.node.override['java']['java_home'] = 'C:/java'
    runner.converge('windows::default', described_recipe)
  end

  it 'should include the notify recipe' do
    expect(chef_run).to include_recipe('java::notify')
  end

  it 'should notify of jdk-version-change' do
    expect(chef_run.windows_package('windows-java')).to notify('log[jdk-version-changed]')
  end
end
