# frozen_string_literal: true

provides :openjdk_pkg_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

use 'partial/_common'
use 'partial/_linux'
use 'partial/_openjdk'

property :pkg_names, [String, Array],
          description: 'List of packages to install'

property :pkg_version, String,
          description: 'Package version to install'

property :java_home, String,
          description: 'Set to override the java_home'

property :bin_cmds, Array,
          description: 'A list of bin_cmds based on the version and variant'

property :alternatives_priority, Integer,
          default: 1062,
          description: 'Alternatives priority to set for this Java'

property :repository_uri, String,
          description: 'URI for the repository mirror (e.g., "https://custom-mirror.example.com/openjdk/ubuntu")'

action :install do
  pkg_names = new_resource.pkg_names || default_openjdk_pkg_names(new_resource.version)
  java_home = new_resource.java_home || default_openjdk_pkg_java_home(new_resource.version)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  if platform?('ubuntu')
    apt_repository 'openjdk-r-ppa' do
      uri new_resource.repository_uri || 'ppa:openjdk-r'
    end
  end

  pkg_version =
    if new_resource.pkg_version && pkg_names.is_a?(String)
      new_resource.pkg_version
    elsif new_resource.pkg_version && pkg_names.is_a?(Array)
      Array.new(pkg_names.size, new_resource.pkg_version)
    end

  package pkg_names do
    version pkg_version if pkg_version
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
  pkg_names = new_resource.pkg_names || default_openjdk_pkg_names(new_resource.version)
  java_home = new_resource.java_home || default_openjdk_pkg_java_home(new_resource.version)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  java_alternatives 'unset-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    only_if { ::File.exist?(java_home) }
    not_if { new_resource.skip_alternatives }
    action :unset
  end

  package pkg_names do
    action :remove
  end

  if platform?('ubuntu')
    apt_repository 'openjdk-r-ppa' do
      uri 'ppa:openjdk-r'
      action :remove
    end
  end
end
