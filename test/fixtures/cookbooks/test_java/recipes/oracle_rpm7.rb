node.default['java']['jdk_version'] = '7'
node.default['java']['install_flavor'] = 'oracle_rpm'
node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'test_java::base'
include_recipe 'java::default'
