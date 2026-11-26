# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'java_jce' do
  context 'install' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['java_jce']) }
    let(:converge) { runner.converge('test::jce_spec') }

    it 'downloads the JCE archive to the explicit download path' do
      expect(converge).to create_remote_file('/tmp/java/jce.zip')
    end

    it 'extracts the archive without a shell execute resource' do
      expect(converge).to extract_archive_file('extract jce')
      expect(converge).to_not run_execute('extract jce')
    end
  end

  context 'remove' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['java_jce']) }
    let(:converge) { runner.converge('test::jce_remove_spec') }

    it 'removes staged JCE artifacts' do
      expect(converge).to delete_directory('/usr/lib/jvm/jce/17')
      expect(converge).to delete_file('/tmp/java/jce.zip')
    end
  end
end
