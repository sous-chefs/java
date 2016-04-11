yum_repository 'oracle-java' do
  description 'mirror of oracle java RPM packages'
  baseurl node['test_java']['oracle_java']['baseurl']
  gpgcheck false
  action :create
end
