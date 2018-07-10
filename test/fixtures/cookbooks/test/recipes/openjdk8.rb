node.default['java']['jdk_version'] = '8'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
