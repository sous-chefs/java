# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'java_certificate' do
  let(:shellout) do
    instance_double(Mixlib::ShellOut, run_command: nil, stdout: '', exitstatus: 0, format_for_exception: '')
  end

  before do
    allow(Mixlib::ShellOut).to receive(:new).and_return(shellout)
  end

  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['java_certificate']) }

  it 'steps into certificate install without invoking host keytool' do
    expect { runner.converge('test::certificate_spec') }.not_to raise_error
  end

  it 'leaves a matching certificate alone when keytool returns CRLF' do
    pem = File.read(File.expand_path('../../test/fixtures/cookbooks/test/files/java_certificate_test.pem', __dir__))
    allow(shellout).to receive(:stdout).and_return("Certificate follows\r\n#{pem.gsub("\n", "\r\n")}")
    allow(Mixlib::ShellOut).to receive(:new).with(anything, '-list', '-cacerts', '-storepass', 'changeit', '-v').and_raise('unexpected full keystore listing')

    expect { runner.converge('test::certificate_spec') }.not_to raise_error
  end

  it 'does not delete an alias when only a longer alias is present' do
    allow(shellout).to receive(:stdout).and_return("Alias name: sample.1-new\r\n")
    allow(Mixlib::ShellOut).to receive(:new).with(anything, '-delete', any_args).and_raise('unexpected deletion')

    expect do
      runner.converge_block { java_certificate('sample.1') { action :remove } }
    end.not_to raise_error
  end

  it 'deletes an exact case-insensitive alias with punctuation' do
    allow(shellout).to receive(:stdout).and_return("Alias name: Sample.1\r\n")
    expect(Mixlib::ShellOut).to receive(:new).with(anything, '-delete', '-alias', 'sample.1', '-cacerts', '-storepass', 'changeit').and_return(shellout)

    runner.converge_block { java_certificate('sample.1') { action :remove } }
  end
end
