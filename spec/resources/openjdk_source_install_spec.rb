# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'openjdk_source_install' do
  let(:cache_path) { Chef::Config[:file_cache_path] }

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

    it 'extracts the archive into the final java_home' do
      archive = converge.resource_collection.find(archive_file: ::File.join(cache_path, 'openjdk.tar.gz'))

      expect(archive.destination).to eq('/usr/lib/jvm/java-17-openjdk/jdk-17')
      expect(archive.strip_components).to eq(1)
      expect(archive.overwrite).to be true
      expect(archive.not_if).not_to be_empty
    end
  end

  context 'custom source URL' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_source_install']) }
    let(:converge) { runner.converge('test::openjdk_source_custom_url_spec') }
    let(:java_home) { '/usr/lib/jvm/java-17-openjdk/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9' }

    it 'derives java_home from the archive file name' do
      resource = converge.resource_collection.find(file: '/etc/profile.d/java.sh')

      expect(resource.content).to eq("export JAVA_HOME=#{java_home}\n")
    end

    it 'sets alternatives to the derived java_home' do
      expect(converge).to set_java_alternatives('set-java-alternatives').with(
        java_location: java_home,
        bin_cmds: %w(java javac)
      )
    end

    it 'extracts the archive into the derived java_home' do
      archive = converge.resource_collection.find(archive_file: ::File.join(cache_path, 'OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'))

      expect(archive.destination).to eq(java_home)
      expect(archive.strip_components).to eq(1)
      expect(archive.overwrite).to be true
      expect(archive.owner).to eq('root')
      expect(archive.group).to eq('root')
      expect(archive.mode).to eq('0755')
      expect(archive.not_if).not_to be_empty
    end
  end

  context 'custom source URL with explicit java_home' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_source_install']) }
    let(:converge) { runner.converge('test::openjdk_source_explicit_java_home_spec') }

    it 'uses the explicit java_home' do
      resource = converge.resource_collection.find(file: '/etc/profile.d/java.sh')

      expect(resource.content).to eq("export JAVA_HOME=/opt/java/custom-openjdk\n")
    end
  end

  context 'custom source URL with source_install_dir' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['openjdk_source_install']) }
    let(:converge) { runner.converge('test::openjdk_source_install_dir_spec') }

    it 'uses source_install_dir under the versioned parent directory' do
      resource = converge.resource_collection.find(file: '/etc/profile.d/java.sh')

      expect(resource.content).to eq("export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/jdk-17.0.9+9\n")
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
