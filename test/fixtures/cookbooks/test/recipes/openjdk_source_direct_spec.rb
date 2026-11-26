declare_resource(:openjdk_source_install, '17') do
  url 'https://example.test/openjdk.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  java_home '/usr/lib/jvm/java-17-openjdk/jdk-17'
  bin_cmds %w(java javac)
  skip_alternatives true
end
