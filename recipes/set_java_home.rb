
Chef::Log.fatal("

java::set_java_home recipe is now deprecated
Use one of the documented install resources
See the documentation folder for a list of resources

")

raise 'Recipe used instead of custom resource'
