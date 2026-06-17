# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'openjdk_pkg_install' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_pkg_install']) }

  let(:converge) do
    runner.converge('test::openjdk_pkg_spec')
  end

  it 'installs the requested OpenJDK packages' do
    expect(converge).to install_package(%w(openjdk-17-jdk openjdk-17-jre-headless))
  end

  it 'does not write node java_home state' do
    expect(converge.node.default_attrs).not_to have_key('java')
    expect(converge.node.normal_attrs).not_to have_key('java')
    expect(converge.node.override_attrs).not_to have_key('java')
  end
end
