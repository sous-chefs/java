# Need bash installed to use bats
if platform_family?('freebsd')
  package 'bash'
end
