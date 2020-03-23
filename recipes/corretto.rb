
Chef::Log.fatal("

java::corretto recipe is now deprecated
Using the corrett_install resource is now recommended
See: https://github.com/sous-chefs/java/blob/master/documentation/resources/corretto_install.md for help

")

raise 'Recipe used instead of custom resource'
