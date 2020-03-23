
Chef::Log.fatal("

Adopt OpenJDK recipe is now deprecated
Using the adoptopenjdk_install resource is now recommended
See: https://github.com/sous-chefs/java/blob/master/documentation/resources/adoptopenjdk_.md for help

")

raise 'Recipe used instead of custom resource'
