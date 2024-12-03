adoptopenjdk_install node['version'] do
  variant node['variant'] if node['variant']
end

include_recipe 'test::java_cert'
