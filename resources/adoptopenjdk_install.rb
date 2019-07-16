#
# Cookbook:: java
# Resource:: adoptopenjdk_install
#
# Based on oracle_install.rb by Bryan W. Berry (<bryan.berry@gmail.com>)
#

resource_name :adoptopenjdk_install

default_action :install

property :url, String
property :checksum, String, regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/
property :md5, String, regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/
property :app_home, String
property :app_home_mode, Integer, default: 0755
property :bin_cmds, Array, default: []
property :owner, String, default: 'root'
property :group, String, default: lazy { node['root_group'] }
property :default, [true, false], default: true
property :alternatives_priority, Integer, default: 1
property :reset_alternatives, [true, false], default: true
property :variant, ['hotspot', 'openj9', 'openj9-large-heap'], default: 'openj9'

action :install do
  raise 'No URL provided to download AdoptOpenJDK\'s tar file!' if new_resource.url.nil? || new_resource.url.empty?
  app_dir_name, tarball_name, app_root, app_dir =
    parse_dir_names(new_resource.url,
                    new_resource.app_home,
                    new_resource.variant)
  app_group = new_resource.group
  app_home = new_resource.app_home
  Chef::Log.debug("processing #{new_resource.variant} variant")

  directory app_root do
    owner new_resource.owner
    group app_group
    mode new_resource.app_home_mode
    recursive true
    action :nothing
  end.run_action(:create)

  unless ::File.exist?(app_dir)
    download_path = "#{node['java']['download_path']}/#{tarball_name}"
    if adoptopendjk_downloaded?(download_path, new_resource)
      Chef::Log.debug('AdoptOpenJDK tarball already downloaded, not downloading again')
    else
      Chef::Log.debug("downloading tarball from #{URI.parse(new_resource.url).host}")
      remote_file "#{node['java']['download_path']}/#{tarball_name}" do
        source new_resource.url
        checksum new_resource.checksum
        retries new_resource.retries
        retry_delay new_resource.retry_delay
        mode 0o644
        action :nothing
      end.run_action(:create_if_missing)
    end

    converge_by("extract compressed data into Chef file cache path and move extracted data to #{app_dir}") do
      package 'tar' do
        not_if { platform_family?('mac_os_x', 'windows') }
        action :nothing
      end.run_action(:install)

      cmd = shell_out(%(tar xvzf "#{node['java']['download_path']}/#{tarball_name}" -C "#{node['java']['download_path']}" --no-same-owner)
                     )
      unless cmd.exitstatus == 0
        Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
      end

      cmd = shell_out(
        %(mv "#{node['java']['download_path']}/#{app_dir_name}" "#{app_dir}" )
      )
      unless cmd.exitstatus == 0
        Chef::Application.fatal!(%( Command \' mv "#{node['java']['download_path']}/#{app_dir_name}" "#{app_dir}" \' failed ))
      end

      # change ownership of extracted files
      FileUtils.chown_R new_resource.owner, app_group, app_dir
    end
  end

  # set up .jinfo file for update-java-alternatives
  java_name, jinfo_file = alternatives_config_file(app_root, app_home)
  if platform_family?('debian') && !::File.exist?(jinfo_file)
    converge_by("Add #{jinfo_file} for debian") do
      template jinfo_file do
        cookbook 'java'
        source 'adoptopenjdk.jinfo.erb'
        owner new_resource.owner
        group app_group
        variables(
          priority: new_resource.alternatives_priority,
          bin_cmds: new_resource.bin_cmds,
          name: java_name,
          app_dir: app_home
        )
        action :nothing
      end.run_action(:create)
    end
  end

  # link app_home to app_dir
  Chef::Log.debug "app_home is #{app_home} and app_dir is #{app_dir}"
  current_link = ::File.symlink?(app_home) ? ::File.readlink(app_home) : nil
  if current_link != app_dir
    converge_by("symlink #{app_dir} to #{app_home}") do
      FileUtils.rm_f app_home
      FileUtils.ln_sf app_dir, app_home
      FileUtils.chown new_resource.owner, app_group, app_home
    end
  end

  # update-alternatives
  java_alternatives 'set-java-alternatives' do
    java_location app_home
    bin_cmds new_resource.bin_cmds
    priority new_resource.alternatives_priority
    default new_resource.default
    reset_alternatives new_resource.reset_alternatives
    action :set
  end
end

action :remove do
  raise 'No URL provided for AdoptOpenJDK\'s tar file!' if new_resource.url.nil? || new_resource.url.empty?
  _app_dir_name, _tarball_name, _app_root, app_dir =
    parse_dir_names(new_resource.url,
                    new_resource.app_home,
                    new_resource.variant)
  app_home = new_resource.app_home
  Chef::Log.debug("processing #{new_resource.variant} variant")

  if ::File.exist?(app_dir)
    java_alternatives 'unset-java-alternatives' do
      java_location app_home
      bin_cmds new_resource.bin_cmds
      action :unset
    end

    directory "AdoptOpenJDK removal of #{app_home}" do
      path app_home
      recursive true
      action :delete
    end
    directory "AdoptOpenJDK removal of #{app_dir}" do
      path app_dir
      recursive true
      action :delete
    end
  end
end

action_class do
  require 'uri'

  def parse_app_dir_name(url)
    uri = URI.parse(url)
    file_name = uri.path.split('/').last
    if file_name =~ /jdk\d+u\d+-b\d+/ # OpenJDK8
      dir_name_results = file_name.scan(/_(jdk\d+u\d+-b\d+)(?:_openj[-.\d]+)?\.tar\.gz$/)
      app_dir_name = dir_name_results[0][0] unless dir_name_results.empty?
    elsif file_name =~ /_\d+u\d+b\d+\.tar\.gz$/ # OpenJDK8U
      dir_name_results = file_name.scan(/_(\d+u\d+)(b\d+)\.tar\.gz$/)
      app_dir_name = "jdk#{dir_name_results[0][0]}-#{dir_name_results[0][1]}" unless dir_name_results.empty?
    else
      dir_name_results = file_name.scan(/[-_]([.\d]+)[._]([\d]+)(?:_openj[-.\d]+)?\.tar\.gz$/)
      app_dir_name = "jdk-#{dir_name_results[0][0]}+#{dir_name_results[0][1]}" unless dir_name_results.empty?
    end
    Chef::Application.fatal!("Failed to parse #{file_name} for application directory name!") if dir_name_results.empty?

    [app_dir_name, file_name]
  end

  def parse_dir_names(url, app_home, variant)
    app_dir_name, tarball_name = parse_app_dir_name(url)
    app_root = app_home.split('/')[0..-2].join('/')
    app_dir = "#{app_root}/#{app_dir_name}-#{variant}"
    [app_dir_name, tarball_name, app_root, app_dir]
  end

  def alternatives_config_file(app_root, app_home)
    java_name = app_home.split('/')[-1]
    config_file = "#{app_root}/.#{java_name}.jinfo"
    [java_name, config_file]
  end

  def adoptopendjk_downloaded?(download_path, new_resource)
    if ::File.exist? download_path
      require 'openssl'
      if new_resource.checksum =~ /^[0-9a-f]{32}$/
        downloaded_md5 =  OpenSSL::Digest::MD5.file(download_path).hexdigest
        downloaded_md5 == new_resource.checksum
      else
        downloaded_sha =  OpenSSL::Digest::SHA256.file(download_path).hexdigest
        downloaded_sha == new_resource.checksum
      end
    else
      false
    end
  end
end
