require 'spec_helper'

RSpec.describe Java::Cookbook::AdoptOpenJdkHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::AdoptOpenJdkHelpers
  end

  subject { DummyClass.new }

  describe '#sub_dir' do
    before do
      allow(subject).to receive(:[]).with('url').and_return(url)
    end

    context 'AdoptOpenJDK 8 Hotspot' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u242b08.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'OpenJDK 8 OpenJ9' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_8u242b08_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'OpenJKDK 8 LargeHeap' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u242b08_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'AdoptOpenJDK 11 Hotspot' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'AdoptOpenJDK 11 OpenJ9' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_11.0.6_10_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'AdoptOpenJDK 11 LargeHeap' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_linuxXL_11.0.6_10_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'AdoptOpenJDK 14 Hotspot' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36/OpenJDK14U-jdk_x64_linux_hotspot_14_36.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-14+36'
      end
    end

    context 'AdoptOpenJDK 14 LargeHeap' do
      let(:url) { 'https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36.1_openj9-0.19.0/OpenJDK14U-jdk_x64_linux_openj9_linuxXL_14_36_openj9-0.19.0.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-14+36'
      end
    end

    context 'Custom URL: AdoptOpenJDK 8 Hotspot' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK8U-jdk_x64_linux_hotspot_8u242b08.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'Custom URL: OpenJDK 8 OpenJ9' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK8U-jdk_x64_linux_openj9_8u242b08_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'Custom URL: OpenJKDK 8 LargeHeap' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u242b08_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk8u242-b08'
      end
    end

    context 'Custom URL: AdoptOpenJDK 11 Hotspot' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'Custom URL: AdoptOpenJDK 11 OpenJ9' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK11U-jdk_x64_linux_openj9_11.0.6_10_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'Custom URL: AdoptOpenJDK 11 LargeHeap' do
      let(:url) { 'https://some.custom.url/path/to/OpenJDK11U-jdk_x64_linux_openj9_linuxXL_11.0.6_10_openj9-0.18.1.tar.gz' }

      it 'returns the correct folder name' do
        expect(subject.sub_dir(url)).to eq 'jdk-11.0.6+10'
      end
    end

    context 'Malformed URL' do
      let(:url) { 'a\bad/path/\to\/some.tar.gz' }

      it 'throws an error' do
        expect { subject.sub_dir(url) }.to raise_error(URI::InvalidURIError)
      end
    end
  end

  describe '#default_adopt_openjdk_url' do
    before do
      allow(subject).to receive(:[]).with('version').and_return(version)
    end

    context 'AdoptOpenJDK 11 LargeHeap' do
      let(:version) { '11' }
      let(:variant) { 'openj9-large-heap' }

      it 'returns the correct URL' do
        expect(subject.default_adopt_openjdk_url(version)[variant]).to eq 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_linuxXL_11.0.6_10_openj9-0.18.1.tar.gz'
      end
    end

    context 'AdoptOpenJDK 11 OpenJ9' do
      let(:version) { '11' }
      let(:variant) { 'openj9' }

      it 'returns the correct URL' do
        expect(subject.default_adopt_openjdk_url(version)[variant]).to eq 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_11.0.6_10_openj9-0.18.1.tar.gz'
      end
    end
  end
end
