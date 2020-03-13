
Chef::Log.fatal("

java::corretto recipe is now deprecated
Using the corrett_install resource is now recommended
See: documentation/resources/install_corretto.md for help

")

raise 'Recipe used instead of custom resource'
