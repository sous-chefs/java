# Doing this configuration here instead of attributes/default.rb so that the user has the ability
# to override node['java']['jdk_version'] and node['java']['install_flavor'] using a data bag
# item, e.g. through bag_config.

case node['platform_family']
when "rhel", "fedora"
  node.default['java']['java_home'] = "/usr/lib/jvm/java"
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
