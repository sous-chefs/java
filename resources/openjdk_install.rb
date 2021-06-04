provides :openjdk_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers

property :version, String, name_property: true, description: 'Java major version to install'
property :install_type, String,
  default: lazy { default_openjdk_install_method(version) },
  equal_to: %w( package source ),
  description: 'Installation type'
property :pkg_names, [String, Array], description: 'List of packages to install'
property :pkg_version, String, description: 'Package version to install'
property :java_home, String, description: 'Set to override the java_home'
property :default, [true, false], description: ' Whether to set this as the defalut Java'
property :bin_cmds, Array, description: 'A list of bin_cmds based on the version and variant'
property :alternatives_priority, Integer, description: 'Alternatives priority to set for this Java'
property :reset_alternatives, [true, false], description: 'Whether to reset alternatives before setting'
property :url, String, description: 'The URL to download from'
property :checksum, String, description: 'The checksum for the downloaded file'
property :java_home_mode, String,  description: 'The permission for the Java home directory'
property :java_home_owner, String, description: 'Owner of the Java Home'
property :java_home_group, String, description: 'Group for the Java Home'

action :install do
  if new_resource.install_type == 'package'
    openjdk_pkg_install new_resource.version do
      pkg_names new_resource.pkg_names
      pkg_version new_resource.pkg_version
      java_home new_resource.java_home
      default new_resource.default
      bin_cmds new_resource.bin_cmds
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
    end
  elsif new_resource.install_type == 'source'
    openjdk_source_install new_resource.version do
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home
      java_home_mode new_resource.java_home_mode
      java_home_group new_resource.java_home_group
      default new_resource.default
      bin_cmds new_resource.bin_cmds
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
    end
  else
    ChefLog.fatal('Invalid install method specified')
  end
end

action :remove do
  if new_resource.install_type == 'package'
    openjdk_pkg_install new_resource.version do
      pkg_names new_resource.pkg_names
      pkg_version new_resource.pkg_version
      java_home new_resource.java_home
      default new_resource.default
      bin_cmds new_resource.bin_cmds
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
      action :remove
    end
  elsif new_resource.install_type == 'source'
    openjdk_source_install new_resource.version do
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home
      java_home_mode new_resource.java_home_mode
      java_home_group new_resource.java_home_group
      default new_resource.default
      bin_cmds new_resource.bin_cmds
      alternatives_priority new_resource.alternatives_priority
      reset_alternatives new_resource.reset_alternatives
      action :remove
    end
  else
    ChefLog.fatal('Invalid install method specified')
  end
end
