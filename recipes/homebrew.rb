include_recipe 'homebrew'
include_recipe 'homebrew::cask'

homebrew_tap 'caskroom/versions'
homebrew_cask "java#{node['java']['jdk_version']}"
