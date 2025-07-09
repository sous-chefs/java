provides :temurin_package_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::TemurinHelpers

def default_temurin_pkg_name(version)
  # Validate version against available releases
  unless temurin_version_available?(version)
    Chef::Log.warn("Temurin version #{version} might not be available. Available LTS versions: #{temurin_lts_versions.join(', ')}")
  end
  "temurin-#{version}-jdk"
end

property :pkg_name, String,
         default: lazy { default_temurin_pkg_name(version) },
         description: 'Package name to install'

property :pkg_version, String,
         description: 'Package version to install'

property :java_home, String,
         default: lazy { default_openjdk_pkg_java_home(version) },
         description: 'Set to override the java_home'

property :bin_cmds, Array,
         default: lazy { default_openjdk_bin_cmds(version) },
         description: 'A list of bin_cmds based on the version'

use 'partial/_common'
use 'partial/_linux'

action :install do
  # Debian/Ubuntu repository setup
  apt_repository 'adoptium' do
    uri 'https://packages.adoptium.net/artifactory/deb'
    components ['main']
    distribution node['lsb']['codename'] || node['debian']['distribution_codename']
    key '843C48A565F8F04B'
    keyserver 'keyserver.ubuntu.com'
    only_if { platform_family?('debian') }
  end

  # RHEL/Fedora/Amazon repository setup
  yum_repository 'adoptium' do
    description 'Eclipse Adoptium'
    baseurl value_for_platform(
      %w(redhat centos) => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/rhel/$releasever/$basearch' },
      'fedora' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/fedora/$releasever/$basearch' },
      'amazon' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/amazonlinux/$releasever/$basearch' }
    )
    enabled true
    gpgcheck true
    gpgkey 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  # SUSE repository setup
  zypper_repository 'adoptium' do
    description 'Eclipse Adoptium'
    baseurl 'https://packages.adoptium.net/artifactory/rpm/opensuse/$releasever/$basearch'
    gpgcheck true
    gpgkey 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    action :create
    only_if { platform_family?('suse') }
  end

  pkg_version = new_resource.pkg_version

  package new_resource.pkg_name do
    version pkg_version if pkg_version
  end

  node.default['java']['java_home'] = new_resource.java_home

  java_alternatives 'set-java-alternatives' do
    java_location new_resource.java_home
    bin_cmds new_resource.bin_cmds
    priority new_resource.alternatives_priority
    default new_resource.default
    reset_alternatives new_resource.reset_alternatives
    action :set
  end
end

action :remove do
  java_alternatives 'unset-java-alternatives' do
    java_location new_resource.java_home
    bin_cmds new_resource.bin_cmds
    only_if { ::File.exist?(new_resource.java_home) }
    action :unset
  end

  package new_resource.pkg_name do
    action :remove
  end

  # Remove repositories based on platform
  apt_repository 'adoptium' do
    action :remove
    only_if { platform_family?('debian') }
  end

  yum_repository 'adoptium' do
    action :remove
    only_if { platform_family?('rhel', 'fedora', 'amazon') }
  end

  zypper_repository 'adoptium' do
    action :remove
    only_if { platform_family?('suse') }
  end
end
