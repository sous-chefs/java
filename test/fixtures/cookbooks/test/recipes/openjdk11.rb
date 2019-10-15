node.default['java']['jdk_version'] = '11'

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
