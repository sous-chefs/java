# frozen_string_literal: true

provides :temurin_package_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

use 'partial/_common'
use 'partial/_linux'

def default_temurin_pkg_name(version)
  "temurin-#{version}-jdk"
end

def default_temurin_rpm_baseurl
  return 'https://packages.adoptium.net/artifactory/rpm/amazonlinux/2/$basearch' if platform?('amazon')

  repository_platform = value_for_platform(
    %w(almalinux oracle redhat rocky) => { 'default' => 'rhel' },
    'centos' => { 'default' => 'centos' },
    'fedora' => { 'default' => 'fedora' },
    'default' => node['platform']
  )

  "https://packages.adoptium.net/artifactory/rpm/#{repository_platform}/$releasever/$basearch"
end

property :pkg_name, String,
         description: 'Package name to install'

property :pkg_version, String,
         description: 'Package version to install'

property :java_home, String,
         description: 'Set to override the java_home'

property :bin_cmds, Array,
         description: 'A list of bin_cmds based on the version'

property :repository_uri, String,
         description: 'URI for the repository mirror (e.g., "https://custom-mirror.example.com/artifactory/deb")'

action :install do
  keyring_path = '/usr/share/keyrings/adoptium.asc'
  pkg_name = new_resource.pkg_name || default_temurin_pkg_name(new_resource.version)
  java_home = new_resource.java_home || "/usr/lib/jvm/temurin-#{new_resource.version}-jdk"
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  remote_file keyring_path do
    source 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    mode '0644'
    only_if { platform_family?('debian') }
  end

  apt_repository 'adoptium' do
    uri new_resource.repository_uri || 'https://packages.adoptium.net/artifactory/deb'
    components ['main']
    distribution lazy { node['lsb']['codename'] || node['debian']['distribution_codename'] }
    signed_by keyring_path
    only_if { platform_family?('debian') }
  end

  yum_repository 'adoptium' do
    description 'Eclipse Adoptium'
    baseurl new_resource.repository_uri || default_temurin_rpm_baseurl
    enabled true
    gpgcheck true
    gpgkey 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    only_if { platform_family?('rhel', 'fedora', 'amazon', 'rocky', 'suse', 'oraclelinux') }
  end

  zypper_repository 'adoptium' do
    description 'Eclipse Adoptium'
    baseurl new_resource.repository_uri || 'https://packages.adoptium.net/artifactory/rpm/opensuse/$releasever/$basearch'
    gpgcheck true
    gpgkey 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    action :create
    only_if { platform_family?('suse') }
  end

  package pkg_name do
    version new_resource.pkg_version if new_resource.pkg_version
  end

  java_alternatives 'set-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    priority new_resource.alternatives_priority
    default new_resource.default
    reset_alternatives new_resource.reset_alternatives
    not_if { new_resource.skip_alternatives }
  end
end

action :remove do
  pkg_name = new_resource.pkg_name || default_temurin_pkg_name(new_resource.version)
  java_home = new_resource.java_home || "/usr/lib/jvm/temurin-#{new_resource.version}-jdk"
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  java_alternatives 'unset-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    only_if { ::File.exist?(java_home) }
    action :unset
    not_if { new_resource.skip_alternatives }
  end

  package pkg_name do
    action :remove
  end

  apt_repository 'adoptium' do
    action :remove
    only_if { platform_family?('debian') }
  end

  file '/usr/share/keyrings/adoptium.asc' do
    action :delete
    only_if { platform_family?('debian') }
  end

  yum_repository 'adoptium' do
    action :remove
    only_if { platform_family?('rhel', 'fedora', 'amazon', 'rocky', 'suse', 'oraclelinux') }
  end

  zypper_repository 'adoptium' do
    action :remove
    only_if { platform_family?('suse') }
  end
end
