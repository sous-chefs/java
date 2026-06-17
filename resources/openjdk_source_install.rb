# frozen_string_literal: true

provides :openjdk_source_install
unified_mode true
include Java::Cookbook::OpenJdkHelpers
include Java::Cookbook::BinCmdHelpers

property :version, String,
          name_property: true,
          description: 'Java version to install'

property :url, String,
          description: 'The URL to download from. Can be an internal mirror URL (e.g., "https://internal-mirror.example.com/java/openjdk/").'

property :checksum, String,
          regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/,
          description: 'The checksum for the downloaded file'

property :java_home, String,
          description: 'Set to override the java_home'

property :bin_cmds, Array,
          description: 'A list of bin_cmds based on the version and variant'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'
use 'partial/_openjdk'

action :install do
  url = new_resource.url || default_openjdk_url(new_resource.version, new_resource.variant)
  checksum = new_resource.checksum || default_openjdk_checksum(new_resource.version)
  java_home = new_resource.java_home || "/usr/lib/jvm/java-#{new_resource.version}-openjdk/jdk-#{new_resource.version}"
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)
  extract_dir = java_home.split('/')[0..-2].join('/')
  parent_dir = java_home.split('/')[0..-3].join('/')
  tarball_name = url.split('/').last

  directory parent_dir do
    owner new_resource.java_home_owner
    group new_resource.java_home_group
    mode new_resource.java_home_mode
    recursive true
  end

  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    source url
    checksum checksum
    retries new_resource.retries
    retry_delay new_resource.retry_delay
    mode '644'
  end

  archive_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    destination extract_dir
  end

  java_alternatives 'set-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    priority new_resource.alternatives_priority
    default new_resource.default
    reset_alternatives new_resource.reset_alternatives
    not_if { new_resource.skip_alternatives }
    action :set
  end

  file '/etc/profile.d/java.sh' do
    content "export JAVA_HOME=#{java_home}\n"
    owner 'root'
    group 'root'
    mode '0644'
  end
end

action :remove do
  java_home = new_resource.java_home || "/usr/lib/jvm/java-#{new_resource.version}-openjdk/jdk-#{new_resource.version}"
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)
  extract_dir = java_home.split('/')[0..-2].join('/')

  java_alternatives 'unset-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    only_if { ::File.exist?(extract_dir) }
    not_if { new_resource.skip_alternatives }
    action :unset
  end

  directory "Removing #{extract_dir}" do
    path extract_dir
    recursive true
    only_if { ::File.exist?(extract_dir) }
    action :delete
  end

  file '/etc/profile.d/java.sh' do
    action :delete
  end
end
