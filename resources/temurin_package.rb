provides :temurin_package
unified_mode true

action :install do
  apt_repository 'adoptium' do
    uri 'https://packages.adoptium.net/artifactory/deb'
    distribution "#{node['lsb']['codename']}"
    components ['main']
    key 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
    keyserver 'keyserver.ubuntu.com'
  end

  package 'temurin-17-jdk'
end
