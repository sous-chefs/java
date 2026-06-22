# frozen_string_literal: true

provides :openjdk_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

property :install_type,
          String,
          equal_to: %w( package source ),
          description: 'Installation type'

property :pkg_names,
          [String, Array],
          description: 'List of packages to install'

property :pkg_version,
          String,
          description: 'Package version to install'

property :java_home,
          String,
          description: 'Set to override the java_home'

property :source_install_dir,
          String,
          description: 'Directory under the versioned parent path where the source archive is installed'

property :bin_cmds,
          Array,
          description: 'A list of bin_cmds based on the version and variant'

property :url,
          String,
          description: 'The URL to download from'

property :checksum,
          String,
          description: 'The checksum for the downloaded file'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'
use 'partial/_openjdk'

action :install do
  install_type = new_resource.install_type || default_openjdk_install_method(new_resource.version)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  if install_type == 'package'
    openjdk_pkg_install new_resource.version do
      pkg_names new_resource.pkg_names
      pkg_version new_resource.pkg_version
      java_home new_resource.java_home
      default new_resource.default
      bin_cmds bin_cmds
      skip_alternatives new_resource.skip_alternatives
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
    end
  elsif install_type == 'source'
    openjdk_source_install new_resource.version do
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home
      source_install_dir new_resource.source_install_dir
      java_home_mode new_resource.java_home_mode
      java_home_owner new_resource.java_home_owner
      java_home_group new_resource.java_home_group
      default new_resource.default
      bin_cmds bin_cmds
      skip_alternatives new_resource.skip_alternatives
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
    end
  else
    ChefLog.fatal('Invalid install method specified')
  end
end

action :remove do
  install_type = new_resource.install_type || default_openjdk_install_method(new_resource.version)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  if install_type == 'package'
    openjdk_pkg_install new_resource.version do
      pkg_names new_resource.pkg_names
      pkg_version new_resource.pkg_version
      java_home new_resource.java_home
      default new_resource.default
      bin_cmds bin_cmds
      skip_alternatives new_resource.skip_alternatives
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
      action :remove
    end
  elsif install_type == 'source'
    openjdk_source_install new_resource.version do
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home
      source_install_dir new_resource.source_install_dir
      java_home_mode new_resource.java_home_mode
      java_home_owner new_resource.java_home_owner
      java_home_group new_resource.java_home_group
      default new_resource.default
      bin_cmds bin_cmds
      skip_alternatives new_resource.skip_alternatives
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
      action :remove
    end
  else
    ChefLog.fatal('Invalid install method specified')
  end
end
