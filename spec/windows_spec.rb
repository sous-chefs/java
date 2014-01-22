require 'chefspec'

describe 'java::windows' do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
