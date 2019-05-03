node.default['java']['jdk_version'] = '8'
node.default['java']['install_flavor'] = 'corretto'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
