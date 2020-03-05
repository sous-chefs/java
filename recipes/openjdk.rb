
Chef::Log.fatal("

OpenJDK recipe is now deprecated
Using the adoptopenjdk_install resource is now recommended
See: documentation/resources/install_openjdk.md for help

")

raise 'Recipe used instead of custom resource'
