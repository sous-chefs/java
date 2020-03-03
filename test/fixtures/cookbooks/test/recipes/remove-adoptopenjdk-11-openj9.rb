apt_update

include_recipe 'test::adoptopenjdk-11-openj9'

adoptopenjdk_install '11' do
  variant 'openj9'
  action :remove
end
