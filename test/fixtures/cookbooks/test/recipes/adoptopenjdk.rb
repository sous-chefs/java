apt_update

version = node['version']
variant = node['variant']

adoptopenjdk_install version do
  variant variant
end

cookbook_file '/tmp/UnlimitedSupportJCETest.jar' do
  source 'UnlimitedSupportJCETest.jar'
end

include_recipe 'test::java_cert'
