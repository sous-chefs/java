require 'chefspec'

describe 'java::windows' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(
      :platform => 'windows',
      :version => '2008R2'
    )
    runner.node.set['java']['windows']['url'] = 'http://example.com/windows-java.msi'
    runner.node.set['java']['java_home'] = 'C:/java'
    runner.converge('windows::default',described_recipe)
  end
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
