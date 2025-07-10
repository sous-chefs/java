provides :openjdk_pkg_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

property :pkg_names, [String, Array],
          default: lazy { default_openjdk_pkg_names(version) },
          description: 'List of packages to install'

property :pkg_version, String,
          description: 'Package version to install'

property :java_home, String,
          default: lazy { default_openjdk_pkg_java_home(version) },
          description: 'Set to override the java_home'

property :bin_cmds, Array,
          default: lazy { default_bin_cmds(version) },
          description: 'A list of bin_cmds based on the version and variant'

property :alternatives_priority, Integer,
          default: 1062,
          description: 'Alternatives priority to set for this Java'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_openjdk'

action :install do
  if platform?('ubuntu')
    apt_repository 'openjdk-r-ppa' do
      uri 'ppa:openjdk-r'
    end
  end

  pkg_version =
    if new_resource.pkg_version && new_resource.pkg_names.is_a?(String)
      version new_resource.pkg_version
    elsif new_resource.pkg_version && new_resource.pkg_names.is_a?(Array)
      Array.new(new_resource.pkg_names.size, new_resource.pkg_version)
    end

  package new_resource.pkg_names do
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

  package new_resource.pkg_names do
    action :remove
  end

  if platform?('ubuntu')
    apt_repository 'openjdk-r-ppa' do
      uri 'ppa:openjdk-r'
      action :remove
    end
  end
end
