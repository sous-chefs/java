# Test recipe for verifying installation paths
# This focuses only on path verification, avoiding non-idempotent operations

openjdk_install node['version'].to_s do
  variant node['variant'] if node['variant']
end
