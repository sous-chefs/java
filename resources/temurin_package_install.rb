provides :temurin_package_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::TemurinHelpers
include Java::Cookbook::BinCmdHelpers

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
         default: lazy { "/usr/lib/jvm/temurin-#{version}-jdk" },
         description: 'Set to override the java_home'

property :bin_cmds, Array,
         default: lazy { default_bin_cmds(version) },
         description: 'A list of bin_cmds based on the version'

property :repository_uri, String,
         description: 'URI for the repository mirror (e.g., "https://custom-mirror.example.com/artifactory/deb")'

use 'partial/_common'
use 'partial/_linux'

action :install do
  apt_repository 'adoptium' do
    uri new_resource.repository_uri || 'https://packages.adoptium.net/artifactory/deb'
    components ['main']
    distribution lazy { node['lsb']['codename'] || node['debian']['distribution_codename'] }
    # TODO: https://github.com/chef/chef/pull/15043
    # key '843C48A565F8F04B'
    # keyserver 'keyserver.ubuntu.com'
    signed_by false
    trusted true
    only_if { platform_family?('debian') }
  end

  yum_repository 'adoptium' do
    description 'Eclipse Adoptium'
    baseurl new_resource.repository_uri || value_for_platform(
      'amazon' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/amazonlinux/2/$basearch' },
      'centos' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/centos/$releasever/$basearch' },
      'fedora' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/fedora/$releasever/$basearch' },
      'opensuse' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/opensuse/$releasever/$basearch' },
      'oracle' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/oraclelinux/$releasever/$basearch' },
      'redhat' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/rhel/$releasever/$basearch' },
      'rocky' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/rocky/8/$basearch' },
      'suse' => { 'default' => 'https://packages.adoptium.net/artifactory/rpm/sles/$releasever/$basearch' }
    )
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

  package new_resource.pkg_name do
    version new_resource.pkg_version if new_resource.pkg_version
  end

  node.default['java']['java_home'] = new_resource.java_home

  java_alternatives 'set-java-alternatives' do
    java_location new_resource.java_home
    bin_cmds new_resource.bin_cmds
    priority new_resource.alternatives_priority
    default new_resource.default
    reset_alternatives new_resource.reset_alternatives
    not_if { new_resource.skip_alternatives }
  end
end

action :remove do
  java_alternatives 'unset-java-alternatives' do
    java_location new_resource.java_home
    bin_cmds new_resource.bin_cmds
    only_if { ::File.exist?(new_resource.java_home) }
    action :unset
    not_if { new_resource.skip_alternatives }
  end

  package new_resource.pkg_name do
    action :remove
  end

  apt_repository 'adoptium' do
    action :remove
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
