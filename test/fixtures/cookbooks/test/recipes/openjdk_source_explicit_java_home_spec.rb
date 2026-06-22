declare_resource(:openjdk_source_install, '17') do
  url 'https://artifacts.example.test/java/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  java_home '/opt/java/custom-openjdk'
  bin_cmds %w(java javac)
end
