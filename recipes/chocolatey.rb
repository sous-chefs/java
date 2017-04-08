include_recipe 'java::notify'

chocolatey_package "jdk#{node['java']['jdk_version']}" do
  action :install
  notifies :write, 'log[jdk-version-changed]', :immediately
end
