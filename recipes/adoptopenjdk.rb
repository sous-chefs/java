
Chef::Log.fatal("

Adopt OpenJDK recipe is now deprecated
Using the adoptopenjdk_install resource is now recommended
See: documentation/resources/install_adoptopenjdk.md for help

")

raise 'Recipe used instead of custom resource'
