declare_resource(:openjdk_install, '17') do
  install_type 'source'
  url 'https://example.test/openjdk.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  java_home '/usr/lib/jvm/java-17-openjdk/jdk-17'
  source_install_dir 'jdk-17.0.9+9'
  java_home_owner 'javauser'
  bin_cmds %w(java javac)
  skip_alternatives true
end
