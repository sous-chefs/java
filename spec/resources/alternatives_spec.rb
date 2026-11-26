# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'java_alternatives' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['java_alternatives']) }

  it 'converges with an empty command list without shelling out' do
    expect { runner.converge('test::alternatives_spec') }.not_to raise_error
  end

  it 'supports unsetting command alternatives' do
    stubs_for_provider('java_alternatives[test-unset-alternatives]') do |provider|
      allow(provider).to receive_shell_out('update-alternatives', '--remove', 'java', '/opt/java/bin/java')
    end

    expect { runner.converge('test::alternatives_unset_spec') }.not_to raise_error
  end

  it 'does not reinstall an existing Debian alternative' do
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with('/opt/java/bin/java').and_return(true)
    allow(::File).to receive(:exist?).with('/var/lib/dpkg/alternatives/java').and_return(true)
    allow(::File).to receive(:exist?).with('/var/lib/alternatives/java').and_return(false)

    stubs_for_provider('java_alternatives[test-existing-alternatives]') do |provider|
      display = <<~OUTPUT
        java - auto mode
          link best version is /opt/java/bin/java
          link currently points to /opt/java/bin/java
          link java is /usr/bin/java
        /opt/java/bin/java - priority 1062
      OUTPUT

      allow(provider).to receive(:shell_out)
        .with('update-alternatives', '--display', 'java')
        .and_return(instance_double(Mixlib::ShellOut, stdout: display, exitstatus: 0))
      allow(provider).to receive(:shell_out!) do |*args|
        raise "unexpected shell_out!: #{args.join(' ')}"
      end
    end

    expect { runner.converge('test::alternatives_existing_spec') }.not_to raise_error
  end
end
