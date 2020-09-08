apt_update

include_recipe 'test::adoptopenjdk'

adoptopenjdk_install '11' do
  variant 'openj9'
  action :remove
end
