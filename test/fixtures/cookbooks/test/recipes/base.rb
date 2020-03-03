apt_update if platform_family?('debian')

cookbook_file '/tmp/UnlimitedSupportJCETest.jar' do
  source 'UnlimitedSupportJCETest.jar'
end
