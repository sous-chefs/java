provides :openjdk_source_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

property :version, String,
          name_property: true,
          description: 'Java version to install'

property :url, String,
          default: lazy { default_openjdk_url(version, variant) },
          description: 'The URL to download from'

property :checksum, String,
          regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/,
          default: lazy { default_openjdk_checksum(version) },
          description: 'The checksum for the downloaded file'

property :java_home, String,
          default: lazy { "/usr/lib/jvm/java-#{version}-openjdk/jdk-#{version}" },
          description: 'Set to override the java_home'

property :bin_cmds, Array,
          default: lazy { default_bin_cmds(version) },
          description: 'A list of bin_cmds based on the version and variant'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'
use 'partial/_openjdk'

action :install do
  extract_dir = new_resource.java_home.split('/')[0..-2].join('/')
  parent_dir = new_resource.java_home.split('/')[0..-3].join('/')
  tarball_name = new_resource.url.split('/').last

  directory parent_dir do
    owner new_resource.java_home_owner
    group new_resource.java_home_group
    mode new_resource.java_home_mode
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    source new_resource.url
    checksum new_resource.checksum
    retries new_resource.retries
    retry_delay new_resource.retry_delay
    mode '644'
  end

  archive_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    destination extract_dir
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

  append_if_no_line 'Java Home' do
    path '/etc/profile.d/java.sh'
    line "export JAVA_HOME=#{new_resource.java_home}"
  end
end

action :remove do
  extract_dir = new_resource.java_home.split('/')[0..-2].join('/')

  java_alternatives 'unset-java-alternatives' do
    java_location new_resource.java_home
    bin_cmds new_resource.bin_cmds
    only_if { ::File.exist?(extract_dir) }
    action :unset
  end

  directory "Removing #{extract_dir}" do
    path extract_dir
    recursive true
    only_if { ::File.exist?(extract_dir) }
    action :delete
  end
end
