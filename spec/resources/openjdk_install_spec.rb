# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'openjdk_install' do
  context 'package install' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_install']) }

    let(:converge) do
      runner.converge('test::openjdk_package_spec')
    end

    it 'delegates to openjdk_pkg_install' do
      expect(converge).to install_openjdk_pkg_install('17').with(
        pkg_names: %w(openjdk-17-jdk openjdk-17-jre-headless),
        java_home: '/usr/lib/jvm/java-17-openjdk-amd64',
        bin_cmds: %w(java javac),
        skip_alternatives: true
      )
    end
  end

  context 'source install' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_install']) }

    let(:converge) do
      runner.converge('test::openjdk_source_spec')
    end

    it 'delegates to openjdk_source_install' do
      expect(converge).to install_openjdk_source_install('17').with(
        url: 'https://example.test/openjdk.tar.gz',
        checksum: 'a' * 64,
        java_home: '/usr/lib/jvm/java-17-openjdk/jdk-17',
        bin_cmds: %w(java javac),
        skip_alternatives: true
      )
    end
  end
end
