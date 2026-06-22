java_alternatives 'test-unset-alternatives' do
  java_location '/opt/java'
  bin_cmds ['java']
  action :unset
end
