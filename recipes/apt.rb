include_recipe 'java::set_java_home'

if node['java']['java_home'].nil? or node['java']['java_home'].empty?
  include_recipe "java::set_attributes_from_version"
end

apt_repository "java-apt-repo" do
  uri node['java']['apt']['uri']
  distribution node["lsb"]["codename"]
  components node['java']['apt']['components'] if node['java']['apt']['components']
  keyserver node['java']['apt']['keyserver'] if node['java']['apt']['keyserver']
  key node['java']['apt']['key'] if node['java']['apt']['key']
  not_if { node['java']['apt']['uri'].empty? }
  only_if { platform_family?('debian') }
end

package node['java']['apt']['package'] do
  action :install
  not_if { node['java']['apt']['package'].empty? }
  only_if { platform_family?('debian') }
end
