node.default['java']['ark_retries'] = 2
node.default['java']['ark_retry_delay'] = 10

apt_update if platform_family?('debian')

# we need bash for bats on FreeBSD
package 'bash' if platform_family?('freebsd')

cookbook_file '/tmp/UnlimitedSupportJCETest.jar' do
  source 'UnlimitedSupportJCETest.jar'
end
