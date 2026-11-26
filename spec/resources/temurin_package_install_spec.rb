# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'temurin_package_install' do
  let(:runner) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '24.04', step_into: ['temurin_package_install']) }

  let(:converge) do
    runner.converge('test::temurin_package_spec')
  end

  it 'installs the Adoptium apt keyring' do
    expect(converge).to create_remote_file('/usr/share/keyrings/adoptium.asc').with(
      source: 'https://packages.adoptium.net/artifactory/api/gpg/key/public',
      mode: '0644'
    )
  end

  it 'configures the apt repository with signed_by instead of trusted mode' do
    expect(converge).to add_apt_repository('adoptium').with(
      signed_by: '/usr/share/keyrings/adoptium.asc'
    )
  end

  it 'installs the Temurin package' do
    expect(converge).to install_package('temurin-17-jdk')
  end

  context 'on AlmaLinux' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'almalinux', version: '8', step_into: ['temurin_package_install']) }

    it 'uses the RHEL-compatible Adoptium RPM repository' do
      expect(converge).to create_yum_repository('adoptium').with(
        baseurl: 'https://packages.adoptium.net/artifactory/rpm/rhel/$releasever/$basearch'
      )
    end
  end

  context 'on Amazon Linux' do
    let(:runner) { ChefSpec::SoloRunner.new(platform: 'amazon', version: '2', step_into: ['temurin_package_install']) }

    it 'uses the Adoptium Amazon Linux 2 RPM repository' do
      expect(converge).to create_yum_repository('adoptium').with(
        baseurl: 'https://packages.adoptium.net/artifactory/rpm/amazonlinux/2/$basearch'
      )
    end
  end
end
