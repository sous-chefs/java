declare_resource(:temurin_package_install, '17') do
  bin_cmds %w(java javac)
  skip_alternatives true
end
