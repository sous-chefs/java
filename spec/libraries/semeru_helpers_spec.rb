require 'spec_helper'

RSpec.describe Java::Cookbook::OpenJdkHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::OpenJdkHelpers
  end

  subject { DummyClass.new }

  describe '#sub_dir' do
    before do
      allow(subject).to receive(:[]).with('url').and_return(url)
    end

    context 'OpenJDK Semeru 8' do
      let(:url) { 'https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u322-b06_openj9-0.30.0/ibm-semeru-open-jdk_x64_linux_8u322b06_openj9-0.30.0.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u322-b06'
      end
    end

    context 'Malformed URL' do
      let(:url) { 'a\bad/path/\to\/some.tar.gz' }

      it 'throws an error' do
        expect { subject.sub_dir(url) }.to raise_error(URI::InvalidURIError)
      end
    end
  end

  describe '#defaul_openjdk_url' do
    before do
      allow(subject).to receive(:[]).with('version').and_return(version)
    end

    context 'Semeru 8' do
      let(:version) { '8' }
      let(:variant) { 'semeru' }

      it 'returns the correct URL' do
        expect(subject.default_openjdk_url(version, variant)).to eq 'https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u322-b06_openj9-0.30.0/ibm-semeru-open-jdk_x64_linux_8u322b06_openj9-0.30.0.tar.gz'
      end
    end

    context 'Semeru 11' do
      let(:version) { '11' }
      let(:variant) { 'semeru' }

      it 'returns the correct URL' do
        expect(subject.default_openjdk_url(version, variant)).to eq 'https://github.com/ibmruntimes/semeru11-binaries/releases/download/jdk-11.0.14.1%2B1_openj9-0.30.1/ibm-semeru-open-jdk_x64_linux_11.0.14.1_1_openj9-0.30.1.tar.gz'
      end
    end

    context 'Semeru 16' do
      let(:version) { '16' }
      let(:variant) { 'semeru' }

      it 'returns the correct URL' do
        expect(subject.default_openjdk_url(version, variant)).to eq 'https://github.com/ibmruntimes/semeru16-binaries/releases/download/jdk-16.0.2%2B7_openj9-0.27.1/ibm-semeru-open-jdk_ppc64le_linux_16.0.2_7_openj9-0.27.1.tar.gz'
      end
    end

    context 'Semeru 17' do
      let(:version) { '17' }
      let(:variant) { 'semeru' }

      it 'returns the correct URL' do
        expect(subject.default_openjdk_url(version, variant)).to eq 'https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.2%2B8_openj9-0.30.0/ibm-semeru-open-jdk_x64_linux_17.0.2_8_openj9-0.30.0.tar.gz'
      end
    end
  end
end

