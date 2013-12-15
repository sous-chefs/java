#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2008-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when "rhel", "fedora"
  node.default['java']['java_home'] = "/usr/lib/jvm/java"
  node.default['java']['openjdk_packages'] = ["java-1.#{node['java']['jdk_version']}.0-openjdk", "java-1.#{node['java']['jdk_version']}.0-openjdk-devel"]
when "freebsd"
  node.default['java']['java_home'] = "/usr/local/openjdk#{node['java']['jdk_version']}"
  node.default['java']['openjdk_packages'] = ["openjdk#{node['java']['jdk_version']}"]
when "arch"
  node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-openjdk"
  node.default['java']['openjdk_packages'] = ["openjdk#{node['java']['jdk_version']}}"]
when "windows"
  node.default['java']['install_flavor'] = "windows"
  node.default['java']['windows']['url'] = nil
  node.default['java']['windows']['checksum'] = nil
  node.default['java']['windows']['package_name'] = "Java(TM) SE Development Kit 7 (64-bit)"
when "debian"
  node.default['java']['java_home'] = "/usr/lib/jvm/java-#{node['java']['jdk_version']}-#{node['java']['install_flavor']}"
  # Newer Debian & Ubuntu adds the architecture to the path
  if node['platform'] == 'debian' && Chef::VersionConstraint.new(">= 7.0").include?(node['platform_version']) ||
     node['platform'] == 'ubuntu' && Chef::VersionConstraint.new(">= 12.04").include?(node['platform_version'])
    node.default['java']['java_home'] = "#{node['java']['java_home']}-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}"
  end
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk", "openjdk-#{node['java']['jdk_version']}-jre-headless"]
when "smartos"
  node.default['java']['java_home'] = "/opt/local/java/sun6"
  node.default['java']['openjdk_packages'] = ["sun-jdk#{node['java']['jdk_version']}", "sun-jre#{node['java']['jdk_version']}"]
else
  node.default['java']['java_home'] = "/usr/lib/jvm/default-java"
  node.default['java']['openjdk_packages'] = ["openjdk-#{node['java']['jdk_version']}-jdk"]
end

include_recipe "java::#{node['java']['install_flavor']}"

# Purge the deprecated Sun Java packages if remove_deprecated_packages is true
%w[sun-java6-jdk sun-java6-bin sun-java6-jre].each do |pkg|
  package pkg do
    action :purge
    only_if { node['java']['remove_deprecated_packages'] }
  end
end
