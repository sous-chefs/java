# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Java::Cookbook::BinCmdHelpers do
  subject(:helper) do
    Class.new do
      include Java::Cookbook::BinCmdHelpers
    end.new
  end

  describe '#default_bin_cmds' do
    it 'returns Java command alternatives for Temurin 25' do
      expect(helper.default_bin_cmds('25')).to include('java', 'javac', 'keytool', 'jwebserver')
    end

    it 'logs a fatal error for unsupported versions' do
      allow(Chef::Log).to receive(:fatal)

      helper.default_bin_cmds('26')

      expect(Chef::Log).to have_received(:fatal).with('Version specified does not have a default set of bin_cmds')
    end
  end
end
