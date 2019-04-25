cookbook_file '/tmp/java_certificate_test.pem' do
  source 'java_certificate_test.pem'
end

# The password for this keystore is 'cheftest'
cookbook_file '/tmp/java_certificate_test_keystore.p12' do
  source 'java_certificate_test_keystore.p12'
end

# The password for the empty keystore is the Java default of 'changeit'
cookbook_file '/tmp/empty_keystore.p12' do
  source 'empty_keystore.p12'
end

java_certificate 'java_certificate_test' do
  cert_file '/tmp/java_certificate_test.pem'
end

java_certificate 'java_certificate_ssl_endpoint' do
  ssl_endpoint 'google.com:443'
end

java_certificate 'test_keystore_cert' do
  cert_type 'keystore'
  source_keystore_path '/tmp/java_certificate_test_keystore.p12'
  source_keystore_passwd 'cheftest'
end

java_certificate 'test_single_keystore_cert' do
  cert_type 'keystore'
  keystore_path '/tmp/empty_keystore.p12'
  source_keystore_path '/tmp/java_certificate_test_keystore.p12'
  source_keystore_passwd 'cheftest'
  source_cert_alias 'testcert-1'
end
