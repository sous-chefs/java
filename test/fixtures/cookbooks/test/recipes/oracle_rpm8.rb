node.default['java']['jdk_version'] = '8'
node.default['java']['install_flavor'] = 'oracle_rpm'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'test::base'
include_recipe 'java::default'
include_recipe 'test::java_cert'
