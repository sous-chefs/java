declare_resource(:corretto_install, '17') do
  url 'https://example.test/corretto.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  java_home '/usr/lib/jvm/java-17-corretto/amazon-corretto-17'
  bin_cmds %w(java javac)
  skip_alternatives true
end
