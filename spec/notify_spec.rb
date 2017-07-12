require 'spec_helper'

describe 'java::notify' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'logs jdk-version-changed' do
    expect(chef_run.log('jdk-version-changed')).to do_nothing
  end
end
