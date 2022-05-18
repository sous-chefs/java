openjdk_install node['version'] do
  variant node['variant'] if node['variant']
end

# openjdk || semeru || temurin
# openjdk OpenJ9 || hotspot

include_recipe 'test::java_cert'
