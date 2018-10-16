node.default['java']['install_flavor'] = 'adoptopenjdk'
node.default['java']['jdk_version'] = '11'
node.default['java']['adoptopenjdk']['variant'] = 'openj9'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'

java_home = node['java']['java_home']
arch = node['java']['arch']
version = node['java']['jdk_version'].to_s
variant = node['java']['adoptopenjdk']['variant']
tarball_url = node['java']['adoptopenjdk'][version][arch][variant]['url']
bin_cmds = if node['java']['adoptopenjdk'][version]['bin_cmds'].key?(variant)
             node['java']['adoptopenjdk'][version]['bin_cmds'][variant]
           else
             node['java']['adoptopenjdk'][version]['bin_cmds']['default']
           end

adoptopenjdk_install 'remove-adoptopenjdk' do
  url tarball_url
  app_home java_home
  bin_cmds bin_cmds
  variant variant
  action :remove
end
