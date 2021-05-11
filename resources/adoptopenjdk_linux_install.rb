resource_name :adoptopenjdk_linux_install
provides :adoptopenjdk_linux_install
unified_mode true

include Java::Cookbook::AdoptOpenJdkHelpers
property :version, String, name_property: true, description: 'Java version to install'

property :variant, String,
  equal_to: %w(hotspot openj9 openj9-large-heap),
  default: 'openj9',
  description: 'Install flavour'

property :url, String,
  default: lazy { default_adopt_openjdk_url(version)[variant] },
  description: 'The URL to download from'

property :checksum, String,
  regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/,
  default: lazy { default_adopt_openjdk_checksum(version)[variant] },
  description: 'The checksum for the downloaded file'

property :java_home, String,
  default: lazy { "/usr/lib/jvm/java-#{version}-adoptopenjdk-#{variant}/#{sub_dir(url)}" },
  description: 'Set to override the java_home'

property :java_home_mode, String,
  description: 'The permission for the Java home directory'

property :java_home_owner, String,
  default: 'root',
  description: 'Owner of the Java Home'

property :java_home_group, String,
  default: lazy { node['root_group'] },
  description: 'Group for the Java Home'

property :default, [true, false],
  default: true,
  description: ' Whether to set this as the defalut Java'

property :bin_cmds, Array,
  default: lazy { default_adopt_openjdk_bin_cmds(version)[variant] },
  description: 'A list of bin_cmds based on the version and variant'

property :alternatives_priority, Integer,
  default: 1,
  description: 'Alternatives priority to set for this Java'

property :reset_alternatives, [true, false],
  default: true,
  description: 'Whether to reset alternatives before setting'

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

  template "/usr/lib/jvm/.java-#{new_resource.version}-adoptopenjdk-#{new_resource.variant}.jinfo" do
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
    action :set
  end

  node.default['java']['java_home'] = new_resource.java_home

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

  directory "AdoptOpenJDK removal of #{extract_dir}" do
    path extract_dir
    recursive true
    only_if { ::File.exist?(extract_dir) }
    action :delete
  end
end
