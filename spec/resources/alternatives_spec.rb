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
end
