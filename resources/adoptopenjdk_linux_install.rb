# provides :adoptopenjdk_linux_install
# unified_mode true
# include Java::Cookbook::OpenJdkHelpers

# property :variant, String,
#           equal_to: %w(hotspot openj9 openj9-large-heap),
#           default: 'openj9',
#           description: 'Install flavour'

# property :url, String,
#           default: lazy { default_openjdk_url(version, variant) },
#           description: 'The URL to download from'

# property :checksum, String,
#           regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/,
#           default: lazy { default_openjdk_checksum(version, variant) },
#           description: 'The checksum for the downloaded file'

# property :java_home, String,
#           default: lazy { "/usr/lib/jvm/java-#{version}-adoptopenjdk-#{variant}/#{sub_dir(url)}" },
#           description: 'Set to override the java_home'

# property :bin_cmds, Array,
#           default: lazy { default_openjdk_bin_cmds(version, variant) },
#           description: 'A list of bin_cmds based on the version and variant'

# use 'partial/_common'
# use 'partial/_linux'
# use 'partial/_java_home'

action :install do
  # template "/usr/lib/jvm/.java-#{new_resource.version}-adoptopenjdk-#{new_resource.variant}.jinfo" do
  #   cookbook 'java'
  #   source 'jinfo.erb'
  #   owner new_resource.java_home_owner
  #   group new_resource.java_home_group
  #   variables(
  #     priority: new_resource.alternatives_priority,
  #     bin_cmds: new_resource.bin_cmds,
  #     name: extract_dir.split('/').last,
  #     app_dir: new_resource.java_home
  #   )
  #   only_if { platform_family?('debian') }
  # end
end
