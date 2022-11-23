require 'spec_helper'

RSpec.describe Java::Cookbook::OpenJdkHelpers do
  class DummyClass < Chef::Node
    include Java::Cookbook::OpenJdkHelpers
  end

  subject { DummyClass.new }

  describe '#lts' do
    it 'returns the currently supported OpenJDK versions minus version 8' do
      expect(subject.lts).to include('11', '17')
    end
  end

  describe '#default_openjdk_url' do
    before do
      allow(subject).to receive(:[]).with(version).and_return(version)
    end

    context 'OpenJDK 17' do
      let(:version) { '17' }

      it 'returns the correct download URL' do
        expect(subject.default_openjdk_url(version)).to eq 'https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
      end
    end

    context 'Invalid OpenJDK version' do
      let(:version) { '18.2' }

      it 'should raise an error' do
        expect { subject.default_openjdk_url(version) }
          .to raise_error('Version supplied does not have a download URL set')
      end
    end
  end

  describe '#default_openjdk_install_method' do
    before do
      allow(subject).to receive(:[]).with(version).and_return(version)
      allow(subject).to receive(:[]).with('platform_family').and_return(platform_family)
      allow(subject).to receive(:[]).with('platform_version').and_return(platform_version)
    end

    context 'Amazon' do
      let(:platform_family) { 'amazon' }
      let(:platform_version) { '2' }
      let(:version) { '17' }
      it 'should default to a source install' do
        expect(subject.default_openjdk_install_method(version)).to eq 'source'
      end
    end

    context 'Debian' do
      let(:platform_family) { 'debian' }

      context '9' do
        let(:platform_version) { '9' }

        context 'OpenJDK 8' do
          let(:version) { '8' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end

        context 'OpenJDK 11' do
          let(:version) { '11' }

          it 'should default to a source install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'source'
          end
        end

        context 'OpenJDK 17' do
          let(:version) { '17' }

          it 'should default to a source install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'source'
          end
        end
      end

      context '10' do
        let(:platform_version) { '10' }

        context 'OpenJDK 17' do
          let(:version) { '17' }

          it 'should default to a source install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'source'
          end
        end

        context 'OpenJDK 11' do
          let(:version) { '11' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end
      end

      context '11' do
        let(:platform_version) { '11' }

        context 'OpenJDK 17' do
          let(:version) { '17' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end

        context 'OpenJDK 11' do
          let(:version) { '11' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end
      end

      context 'Ubuntu 18.04' do
        let(:platform_version) { '18.04' }

        context 'OpenJDK 17' do
          let(:version) { '17' }

          it 'should default to a source install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'source'
          end
        end

        context 'OpenJDK 11' do
          let(:version) { '11' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end
      end

      context 'Ubuntu 20.04' do
        let(:platform_version) { '20.04' }

        context 'OpenJDK 17' do
          let(:version) { '17' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end

        context 'OpenJDK 11' do
          let(:version) { '11' }

          it 'should default to a package install' do
            expect(subject.default_openjdk_install_method(version)).to eq 'package'
          end
        end
      end
    end

    # context 'Debian 11' do
    #   let(:platform_family) { 'debian' }
    #   let(:platform_version) { '10' }
    #   let(:version) { '17' }
    #   it 'should default to a package install' do
    #     expect(subject.default_openjdk_install_method(version)).to eq 'package'
    #   end
    # end
  end
end
