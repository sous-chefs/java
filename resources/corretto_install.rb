provides :corretto_install
unified_mode true
include Java::Cookbook::CorrettoHelpers

property :full_version, String,
          description: 'Used to configure the package directory, change this is the version installed by the package is no longer correct'

property :url, String,
          default: lazy { default_corretto_url(version) },
          description: 'The URL to download from'

property :checksum, String,
          regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/,
          description: 'The checksum for the downloaded file'

property :java_home, String,
          default: lazy { "/usr/lib/jvm/java-#{version}-corretto/#{corretto_sub_dir(version, full_version)}" },
          description: 'Set to override the java_home'

property :bin_cmds, Array,
          default: lazy { default_corretto_bin_cmds(version) },
          description: 'A list of bin_cmds based on the version and variant'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'

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
    checksum new_resource.checksum if new_resource.checksum
    retries new_resource.retries
    retry_delay new_resource.retry_delay
    mode '644'
  end

  archive_file "#{Chef::Config[:file_cache_path]}/#{tarball_name}" do
    destination extract_dir
  end

  node.default['java']['java_home'] = new_resource.java_home

  # Set up .jinfo file for update-java-alternatives
  template "/usr/lib/jvm/.java-#{new_resource.version}-corretto.jinfo" do
    cookbook 'java'
    source 'jinfo.erb'
    owner new_resource.java_home_owner
    group new_resource.java_home_group
    variables(
      priority: new_resource.alternatives_priority,
      bin_cmds: new_resource.bin_cmds,
      name: extract_dir.split('/').last,
      app_dir: new_resource.java_home
    )
    only_if { platform_family?('debian') }
  end

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
