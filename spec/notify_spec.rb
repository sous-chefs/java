require 'spec_helper'

describe 'java::notify' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'logs jdk-version-changed' do
    expect(chef_run.log('jdk-version-changed')).to do_nothing
  end
end
