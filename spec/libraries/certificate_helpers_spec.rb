require 'spec_helper'

RSpec.describe Java::Cookbook::CertificateHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::CertificateHelpers
  end

  subject { DummyClass.new }

  describe '#default_truststore_path' do
    context 'Java 9' do
      let(:version) { '9' }
      let(:java_home) { '/usr/lib/jvm/corretto-9' }

      it 'returns the correct path' do
        expect(subject.default_truststore_path(version, java_home)).to eq('/usr/lib/jvm/corretto-9/lib/security/cacerts')
      end
    end
  end

  describe '#keystore_argument' do
    context 'cacerts set ' do
      let(:cacerts) { true }
      let(:truststore_path) { '/usr/lib/jvm/corretto-9/jre/lib/security/cacerts' }

      it 'returns the correct argument' do
        expect(subject.keystore_argument(cacerts, truststore_path)).to eq('-cacerts')
      end
    end

    context 'no cacerts' do
      let(:cacerts) { false }
      let(:truststore_path) { '/mycertstore.jks' }

      it 'returns the correct argument' do
        expect(subject.keystore_argument(cacerts, truststore_path)).to eq('-keystore /mycertstore.jks')
      end
    end
  end
end
