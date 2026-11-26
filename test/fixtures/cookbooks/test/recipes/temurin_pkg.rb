# This recipe tests the temurin_package_install resource
# It should install temurin java packages based on the version specified

temurin_package_install node['version']
