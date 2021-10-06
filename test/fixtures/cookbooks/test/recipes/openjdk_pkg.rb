openjdk_install node['version'] do
  install_type 'package'
end

include_recipe 'test::java_cert'
