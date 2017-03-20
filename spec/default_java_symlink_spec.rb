require 'spec_helper'

describe 'java::default_java_symlink' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'symlinks /usr/lib/jvm/default-java' do
    link = chef_run.link('/usr/lib/jvm/default-java')
    expect(link).to link_to(chef_run.node['java']['java_home'])
  end
end
