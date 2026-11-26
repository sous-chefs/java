declare_resource(:java_jce, '17') do
  jce_url 'https://example.test/jce.zip'
  jce_checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  java_home '/usr/lib/jvm/java-17-openjdk-amd64'
  jce_home '/usr/lib/jvm/jce'
  download_path '/tmp/java'
  install_type 'jdk'
  action :remove
end
