version = node['version'].to_s
certificate_java_home = node.run_state['java_certificate_java_home']

cookbook_file '/tmp/java_certificate_test.pem' do
  source 'java_certificate_test.pem'
end

java_certificate 'java_certificate_test' do
  cert_file '/tmp/java_certificate_test.pem'
  java_version version
  java_home certificate_java_home if certificate_java_home
end

java_certificate 'java_certificate_ssl_endpoint' do
  ssl_endpoint 'google.com:443'
  java_version version
  java_home certificate_java_home if certificate_java_home
end

java_certificate 'java_certificate_ssl_endpoint' do
  java_version version
  java_home certificate_java_home if certificate_java_home
  action :remove
end

java_certificate 'java_certificate_ssl_endpoint_starttls_smtp' do
  ssl_endpoint 'smtp.gmail.com:587'
  starttls 'smtp'
  java_version version
  java_home certificate_java_home if certificate_java_home
end

java_certificate 'java_certificate_ssl_endpoint_starttls_smtp' do
  java_version version
  java_home certificate_java_home if certificate_java_home
  action :remove
end
