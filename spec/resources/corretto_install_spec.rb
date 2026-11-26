# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'corretto_install' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['corretto_install']) }
  let(:converge) { runner.converge('test::corretto_spec') }

  it 'downloads the Corretto archive' do
    expect(converge).to create_remote_file(::File.join(Chef::Config[:file_cache_path], 'corretto.tar.gz'))
  end

  it 'creates a Debian jinfo file' do
    expect(converge).to create_template('/usr/lib/jvm/.java-17-corretto.jinfo')
  end
end
