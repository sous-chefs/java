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

property :source_install_dir, String,
          description: 'Directory under the versioned parent path where the source archive is installed'

property :bin_cmds, Array,
          description: 'A list of bin_cmds based on the version and variant'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'
use 'partial/_openjdk'

action :install do
  url = new_resource.url || default_openjdk_url(new_resource.version, new_resource.variant)
  checksum = new_resource.checksum || default_openjdk_checksum(new_resource.version)
  java_home = resolved_java_home(url)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)
  tarball_name = url.split('/').last

  directory java_home do
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
    destination java_home
    strip_components 1
    overwrite true
    owner new_resource.java_home_owner
    group new_resource.java_home_group
    mode new_resource.java_home_mode
    not_if { ::File.exist?(::File.join(java_home, 'bin', 'java')) }
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
  url = new_resource.url || default_openjdk_url(new_resource.version, new_resource.variant)
  java_home = resolved_java_home(url)
  bin_cmds = new_resource.bin_cmds || default_bin_cmds(new_resource.version)

  java_alternatives 'unset-java-alternatives' do
    java_location java_home
    bin_cmds bin_cmds
    only_if { ::File.exist?(java_home) }
    not_if { new_resource.skip_alternatives }
    action :unset
  end

  directory "Removing #{java_home}" do
    path java_home
    recursive true
    only_if { ::File.exist?(java_home) }
    action :delete
  end

  file '/etc/profile.d/java.sh' do
    action :delete
  end
end

action_class do
  def resolved_java_home(url)
    return new_resource.java_home if new_resource.java_home

    install_dir =
      if new_resource.source_install_dir
        new_resource.source_install_dir
      elsif new_resource.url
        source_install_dir_from_url(url)
      else
        "jdk-#{new_resource.version}"
      end

    "/usr/lib/jvm/java-#{new_resource.version}-openjdk/#{install_dir}"
  end

  def source_install_dir_from_url(url)
    ::File.basename(::URI.parse(url).path)
          .sub(/\.(?:tar\.(?:gz|bz2|xz)|tgz|tbz2|zip)\z/i, '')
  end
end
