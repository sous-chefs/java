declare_resource(:openjdk_install, '17') do
  install_type 'package'
  pkg_names %w(openjdk-17-jdk openjdk-17-jre-headless)
  java_home '/usr/lib/jvm/java-17-openjdk-amd64'
  bin_cmds %w(java javac)
  skip_alternatives true
end
