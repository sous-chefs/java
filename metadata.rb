name              'java'
maintainer        'Agile Orbit'
maintainer_email  'info@agileorbit.com'
license           'Apache-2.0'
description       'Installs Java runtime.'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.50.0'

recipe 'java::default', 'Installs Java runtime'
recipe 'java::default_java_symlink', 'Updates /usr/lib/jvm/default-java'
recipe 'java::oracle', 'Installs the Oracle flavor of Java'
recipe 'java::purge_packages', 'Purges old Sun JDK packages'
recipe 'java::set_attributes_from_version', 'Sets various attributes that depend on jdk_version'
recipe 'java::set_java_home', 'Sets the JAVA_HOME environment variable'
recipe 'java::oracle_jce', 'Installs the Java Crypto Extension for strong encryption'

%w(
  ubuntu
).each do |os|
  supports os
end

depends 'apt'

source_url 'https://github.com/agileorbit-cookbooks/java'
issues_url 'https://github.com/agileorbit-cookbooks/java/issues'
chef_version '>= 12.1'
