# Cookbook:: java
# Recipe:: corretto
# This recipe installs and configures Amazon's Corretto package
# https://aws.amazon.com/corretto/

include_recipe 'java::notify'

unless node.recipe?('java::default')
  Chef::Log.warn('Using java::default instead is recommended.')

  # Even if this recipe is included by itself, a safety check is nice...
  if node['java']['java_home'].nil? || node['java']['java_home'].empty?
    include_recipe 'java::set_attributes_from_version'
  end
end

java_home = node['java']['java_home']
arch = node['java']['arch']
version = node['java']['jdk_version'].to_s
tarball_url = node['java']['corretto'][version][arch]['url']
tarball_checksum = node['java']['corretto'][version][arch]['checksum']
bin_cmds = node['java']['corretto'][version]['bin_cmds']

include_recipe 'java::set_java_home'

java_oracle_install 'jdk' do
  url tarball_url
  default node['java']['set_default']
  md5 tarball_checksum
  app_home java_home
  bin_cmds bin_cmds
  alternatives_priority node['java']['alternatives_priority']
  retries node['java']['ark_retries']
  retry_delay node['java']['ark_retry_delay']
  connect_timeout node['java']['ark_timeout']
  use_alt_suffix node['java']['use_alt_suffix']
  reset_alternatives node['java']['reset_alternatives']
  download_timeout node['java']['ark_download_timeout']
  proxy node['java']['ark_proxy']
  action :install
  notifies :write, 'log[jdk-version-changed]', :immediately
end

if node['java']['set_default'] && platform_family?('debian')
  include_recipe 'java::default_java_symlink'
end
