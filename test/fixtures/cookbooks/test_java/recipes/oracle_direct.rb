node.default['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'test_java::base'
include_recipe 'java::oracle_direct'
