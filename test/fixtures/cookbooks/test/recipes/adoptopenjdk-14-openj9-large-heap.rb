apt_update

version = '13'
variant = 'openj9-large-heap'

adoptopenjdk_install version do
  variant variant
end

cookbook_file '/tmp/java_certificate_test.pem' do
  source 'java_certificate_test.pem'
end

java_certificate 'java_certificate_test' do
  cert_file '/tmp/java_certificate_test.pem'
  java_version version
end

java_certificate 'java_certificate_ssl_endpoint' do
  ssl_endpoint 'google.com:443'
  java_version version
end

cookbook_file '/tmp/UnlimitedSupportJCETest.jar' do
  source 'UnlimitedSupportJCETest.jar'
end
