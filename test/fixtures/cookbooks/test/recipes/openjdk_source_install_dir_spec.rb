declare_resource(:openjdk_source_install, '17') do
  url 'https://artifacts.example.test/java/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  source_install_dir 'jdk-17.0.9+9'
  bin_cmds %w(java javac)
end
