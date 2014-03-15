link '/usr/lib/jvm/default-java' do
  to node['java']['java_home']
  not_if { node['java']['java_home'] == '/usr/lib/jvm/default-java' }
end
