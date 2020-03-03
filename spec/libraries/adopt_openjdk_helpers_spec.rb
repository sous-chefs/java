require 'spec_helper'

RSpec.describe Java::Cookbook::Helpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::Helpers
  end

  subject { DummyClass.new }

  describe '#sub_dir' do
    before do
      allow(subject).to receive(:[]).with('url').and_return(url)
    end

    context 'AdoptOpenJDK 8 Hotspot' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u232-b09/OpenJDK8U-jdk_x64_linux_hotspot_8u232b09.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u232-b09'
      end
    end

    context 'OpenJDK 8 OpenJ9' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u232-b09_openj9-0.17.0/OpenJDK8U-jdk_x64_linux_openj9_8u232b09_openj9-0.17.0.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u232-b09'
      end
    end

    context 'OpenJKDK 8 Large Heap' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u242b08_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'AdoptOpenJDK 11 Hotspot' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.5_10.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.5+10'
      end
    end

    context 'AdoptOpenJDK 11 OpenJ9' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10_openj9-0.17.0/OpenJDK11U-jdk_x64_linux_openj9_11.0.5_10_openj9-0.17.0.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.5+10'
      end
    end

    context 'AdoptOpenJDK 11 LargeHeap' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.5%2B10_openj9-0.17.0/OpenJDK11U-jdk_x64_linux_openj9_linuxXL_11.0.5_10_openj9-0.17.0.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.5+10'
      end
    end
  end
end
