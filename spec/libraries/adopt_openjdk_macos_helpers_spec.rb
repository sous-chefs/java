require 'spec_helper'

RSpec.describe Java::Cookbook::AdoptOpenJdkMacOsHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::AdoptOpenJdkMacOsHelpers
  end

  subject { DummyClass.new }

  describe '#macos_java_home' do
    before do
      allow(subject).to receive(:[]).with('version').and_return(version)
    end

    context 'adoptopenjdk14' do
      let(:version) { 'adoptopenjdk14' }

      it 'returns the correct folder' do
        expect(subject.macos_java_home(version)).to eq '/Library/Java/JavaVirtualMachines/adoptopenjdk-14.jdk/Contents/Home'
      end
    end

    context 'adoptopenjdk14-openj9-jre' do
      let(:version) { 'adoptopenjdk14-openj9-jre' }

      it 'returns the correct folder' do
        expect(subject.macos_java_home(version)).to eq '/Library/Java/JavaVirtualMachines/adoptopenjdk-14-openj9.jre/Contents/Home'
      end
    end

    context 'adoptopenjdk14-openj9-jre-large' do
      let(:version) { 'adoptopenjdk14-openj9-jre-large' }

      it 'returns the correct folder' do
        expect(subject.macos_java_home(version)).to eq '/Library/Java/JavaVirtualMachines/adoptopenjdk-14-openj9.jre/Contents/Home'
      end
    end

    context 'adoptopenjdk14-openj9-large' do
      let(:version) { 'adoptopenjdk14-openj9-large' }

      it 'returns the correct folder' do
        expect(subject.macos_java_home(version)).to eq '/Library/Java/JavaVirtualMachines/adoptopenjdk-14-openj9.jdk/Contents/Home'
      end
    end
  end
end
