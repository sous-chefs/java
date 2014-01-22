require 'spec_helper'

describe 'java::oracle_i386' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.converge(described_recipe)
  end

  it 'should include the set_java_home recipe' do
    expect(chef_run).to include_recipe('java::set_java_home')
  end

  it 'should configure a java_ark[jdk] resource' do
    pending "Testing LWRP use is not required at this time, this is tested post-converge."
  end
end
