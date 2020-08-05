adoptopenjdk_install node['version'] do
  variant node['variant']
  url node['url']
  checksum node['checksum']
  default true
  alternatives_priority 1
end
