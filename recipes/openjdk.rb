
Chef::Log.fatal("

java::openjdk recipe is now deprecated
Using the openjdk_install resource is now recommended
See: https://github.com/sous-chefs/java/blob/master/documentation/resources/openjdk_install.md for help

")

raise 'Recipe used instead of custom resource'
