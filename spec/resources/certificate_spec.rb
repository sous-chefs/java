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
end
