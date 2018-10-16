node.default['java']['install_flavor'] = 'adoptopenjdk'
node.default['java']['jdk_version'] = '11'
node.default['java']['adoptopenjdk']['variant'] = 'hotspot'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
