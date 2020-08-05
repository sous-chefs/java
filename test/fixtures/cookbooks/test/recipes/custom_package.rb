adoptopenjdk_install node['version'] do
  variant 'hotspot'
  url node['url']
  checksum node['checksum']
  default true
  alternatives_priority 1
end
