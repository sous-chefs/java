cookbook_file '/tmp/java_certificate_test.pem' do
  source 'java_certificate_test.pem'
end

java_certificate 'java_certificate_test' do
  cert_file '/tmp/java_certificate_test.pem'
end
