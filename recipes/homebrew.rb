include_recipe 'homebrew'
include_recipe 'homebrew::cask'
include_recipe 'java::notify'

homebrew_tap 'caskroom/versions'

cask_default_java_version = '8'
pkg_name = if node['java']['jdk_version'].to_s == cask_default_java_version
             'java'
           else
             "java#{node['java']['jdk_version']}"
           end

if node['java']['jdk_version'].to_s == '7'
  log 'java-7-cask-removed' do
    message 'java7 has been removed from caskroom/versions. See https://github.com/caskroom/homebrew-versions/pull/3914'
    level :warn
  end
end

homebrew_cask pkg_name do
  notifies :write, 'log[jdk-version-changed]', :immediately
end
