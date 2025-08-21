version = node['version'].to_s

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

java_certificate 'java_certificate_ssl_endpoint' do
  java_version version
  action :remove
end

java_certificate 'java_certificate_ssl_endpoint_starttls_smtp' do
  ssl_endpoint 'smtp.gmail.com:587'
  starttls 'smtp'
  java_version version
end

java_certificate 'java_certificate_ssl_endpoint_starttls_smtp' do
  java_version version
  action :remove
end
