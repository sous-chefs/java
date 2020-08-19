require 'spec_helper'

RSpec.describe Java::Cookbook::CorrettoHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::CorrettoHelpers
  end

  subject { DummyClass.new }

  describe '#default_corretto_url' do
    before do
      allow(subject).to receive(:[]).with('version').and_return(version)
      allow(subject).to receive(:[]).with('kernel').and_return('machine' => machine)
    end

    context 'Corretto 8 x64' do
      let(:version) { '8' }
      let(:machine) { 'x86_64' }

      it 'returns the correct URL' do
        expect(subject.default_corretto_url(version)).to match /corretto-8.+\.tar.gz/
      end
    end

    context 'Corretto 11 x64' do
      let(:version) { '11' }
      let(:machine) { 'x86_64' }

      it 'returns the correct URL' do
        expect(subject.default_corretto_url(version)).to match /corretto-11.+\.tar.gz/
      end
    end

    context 'Corretto 8 aarch64' do
      let(:version) { '8' }
      let(:machine) { 'aarch64' }

      it 'returns the correct URL' do
        expect(subject.default_corretto_url(version)).to match /corretto-8.+\.tar.gz/
      end
    end

    context 'Corretto 11 aarch64' do
      let(:version) { '11' }
      let(:machine) { 'aarch64' }

      it 'returns the correct URL' do
        expect(subject.default_corretto_url(version)).to match /corretto-11.+\.tar.gz/
      end
    end
  end

  describe '#default_bin_cmds' do
    before do
      allow(subject).to receive(:[]).with('version').and_return(version)
    end

    context 'Corretto 8' do
      let(:version) { '8' }

      it 'returns the correct bin command array' do
        expect(subject.default_corretto_bin_cmds(version)).to include 'appletviewer'
        expect(subject.default_corretto_bin_cmds(version)).to_not include 'jaotc'
      end
    end

    context 'Corretto 11' do
      let(:version) { '11' }

      it 'returns the correct bin command array' do
        expect(subject.default_corretto_bin_cmds(version)).to_not include 'appletviewer'
        expect(subject.default_corretto_bin_cmds(version)).to include 'jaotc'
      end
    end
  end

  describe '#corretto_sub_dir' do
    before do
      allow(subject).to receive(:[]).with('version', 'full_version').and_return(version)
      allow(subject).to receive(:[]).with('kernel').and_return('machine' => machine)
    end

    context 'No full_version passed for Corretto 8 x64' do
      let(:version) { '8' }
      let(:machine) { 'x86_64' }

      it 'returns the default directory value for Corrretto 8 x64' do
        expect(subject.corretto_sub_dir(version)).to include '265'
      end
    end

    context 'No full_version passed for Corretto 8 aarch64' do
      let(:version) { '8' }
      let(:machine) { 'aarch64' }

      it 'returns the default directory value for Corrretto 8 aarch64' do
        expect(subject.corretto_sub_dir(version)).to include '265'
      end
    end

    context 'No full_version passed for Corretto 11 x64' do
      let(:version) { '11' }
      let(:machine) { 'x86_64' }

      it 'returns the default directory value for Corrretto 11 x64' do
        expect(subject.corretto_sub_dir(version)).to include '0.8.10.1'
      end
    end

    context 'No full_version passed for Corretto 11 aarch64' do
      let(:version) { '11' }
      let(:machine) { 'aarch64' }

      it 'returns the default directory value for Corrretto 11 aarch64' do
        expect(subject.corretto_sub_dir(version)).to include '0.8.10.1'
      end
    end

    context 'A full version passed for for Corretto 8 x64' do
      let(:version) { '8' }
      let(:full_version) { '8.123.45.6' }
      let(:machine) { 'x86_64' }

      it 'returns the default directory value for Corrretto 8' do
        expect(subject.corretto_sub_dir(version, full_version)).to include '8.123.45.6'
      end
    end

    context 'A full version passed for for Corretto 8 aarch64' do
      let(:version) { '8' }
      let(:full_version) { '8.123.45.6' }
      let(:machine) { 'aarch64' }

      it 'returns the default directory value for Corrretto 8 aarch64' do
        expect(subject.corretto_sub_dir(version, full_version)).to include '8.123.45.6'
      end
    end
  end
end
