provides :adoptopenjdk_install
unified_mode true

property :variant,
          String,
          description: 'Install flavour', default: 'openj9'

property :url,
          String,
          description: 'The URL to download from'

property :checksum,
          String,
          description: 'The checksum for the downloaded file'

property :java_home,
          String,
          description: 'Set to override the java_home'

property :bin_cmds,
          Array,
          description: 'A list of bin_cmds based on the version and variant'

use 'partial/_common'
use 'partial/_linux'
use 'partial/_java_home'
use 'partial/_macos'

action :install do
  case node['platform_family']
  when 'mac_os_x'
    variant = if new_resource.variant.include? 'openj9'
                ''
              else
                "-#{new_resource.variant}"
              end

    adoptopenjdk_macos_install 'homebrew' do
      tap_url new_resource.tap_url
      cask_options new_resource.cask_options
      homebrew_path new_resource.homebrew_path
      owner new_resource.owner
      version "adoptopenjdk#{new_resource.version}#{variant}"
    end
  when 'windows'
    log 'not yet implemented'
  else
    adoptopenjdk_linux_install new_resource.version do
      variant new_resource.variant
      url new_resource.url
      checksum new_resource.checksum
      java_home new_resource.java_home
      java_home_mode new_resource.java_home_mode
      java_home_group new_resource.java_home_group
    end
  end
end

action :remove do
  case node['platform_family']
  when 'mac_os_x'
    adoptopenjdk_macos_install 'homebrew' do
      tap_url new_resource.tap_url
      cask_options new_resource.cask_options
      homebrew_path new_resource.homebrew_path
      owner new_resource.owner
      action :remove
    end
  when 'windows'
    log 'not yet implemented'
  else
    adoptopenjdk_linux_install 'linux' do
      version new_resource.version unless new_resource.version.nil?
      variant new_resource.variant unless new_resource.variant.nil?
      java_home new_resource.java_home unless new_resource.java_home.nil?
      bin_cmds new_resource.bin_cmds unless new_resource.bin_cmds.nil?
      action :remove
    end
  end
end
