Chef::Log.fatal("

The java::homebrew recipe is now deprecated
Use the homebrew cookbook and resources in your wrapper cookbook
See the documentation folder for a list of resources

")

raise 'Recipe used instead of custom resource'
