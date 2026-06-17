# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'openjdk_source_install' do
  context 'install' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_source_install']) }
    let(:converge) { runner.converge('test::openjdk_source_direct_spec') }

    it 'downloads the source archive' do
      expect(converge).to create_remote_file(::File.join(Chef::Config[:file_cache_path], 'openjdk.tar.gz'))
    end

    it 'sets JAVA_HOME in the profile file' do
      resource = converge.resource_collection.to_a.find do |candidate|
        candidate.resource_name == :file && candidate.name == '/etc/profile.d/java.sh'
      end

      expect(resource.content).to eq("export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/jdk-17\n")
      expect(resource.mode).to eq('0644')
    end
  end

  context 'remove' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_source_install']) }
    let(:converge) { runner.converge('test::openjdk_source_remove_spec') }

    it 'removes the managed JAVA_HOME line' do
      resource = converge.resource_collection.to_a.find do |candidate|
        candidate.resource_name == :file && candidate.name == '/etc/profile.d/java.sh'
      end

      expect(resource.action).to eq([:delete])
    end
  end
end
