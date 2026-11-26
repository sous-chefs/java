extend Java::Cookbook::CorrettoHelpers

version = node['version'].to_s
java_home = "/usr/lib/jvm/java-#{version}-corretto/#{corretto_sub_dir(version)}"

corretto_install version do
  java_home java_home
end

node.run_state['java_certificate_java_home'] = java_home

include_recipe 'test::java_cert'
