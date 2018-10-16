node.default['java']['install_flavor'] = 'adoptopenjdk'
node.default['java']['jdk_version'] = '10'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
