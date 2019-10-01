#
# Author:: Bryan W. Berry (<bryan.berry@gmail.com>)
# Cookbook:: java
# Resource:: oracle_install
#
# Copyright:: 2011, Bryan w. Berry
# Copyright:: 2017-2018, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# backwards compatibility with the old name
provides :java_oracle_install
provides :java_ark

property :url, String
property :mirrorlist, Array, default: []
property :checksum, String, regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/
property :md5, String, regex: /^[0-9a-f]{32}$|^[a-zA-Z0-9]{40,64}$/
property :app_home, String
property :app_home_mode, Integer, default: 0755
property :bin_cmds, Array, default: []
property :owner, String, default: 'root'
property :group, String, default: lazy { node['root_group'] }
property :default, [true, false], default: true
property :alternatives_priority, Integer, default: 1
property :connect_timeout, Integer, default: 30 # => 30 seconds
property :reset_alternatives, [true, false], default: true
property :use_alt_suffix, [true, false], default: true
property :download_timeout, Integer, default: 600 # => 600 seconds
property :proxy, String
property :accept_oracle_download_terms, [true, false], default: lazy { node['java']['oracle']['accept_oracle_download_terms'] }

action :install do
  app_dir_name, tarball_name = parse_app_dir_name(new_resource.url)
  app_root = new_resource.app_home.split('/')[0..-2].join('/')
  app_dir = app_root + '/' + app_dir_name
  app_group = new_resource.group

  if !new_resource.default && new_resource.use_alt_suffix
    Chef::Log.debug('processing alternate jdk')
    app_dir += '_alt'
    app_home = new_resource.app_home + '_alt'
  else
    app_home = new_resource.app_home
  end

  directory app_root do
    owner new_resource.owner
    group app_group
    mode new_resource.app_home_mode
    recursive true
    action :nothing
  end.run_action(:create)

  unless ::File.exist?(app_dir)
    if new_resource.url =~ /oracle\.com.*$/
      download_path = "#{node['java']['download_path']}/#{tarball_name}"
      if oracle_downloaded?(download_path, new_resource)
        Chef::Log.debug('oracle tarball already downloaded, not downloading again')
      else
        Chef::Log.warn('Downloading directly from Oracle is unreliable as artifacts have been removed in the past. Change download url.')
        download_direct_from_oracle tarball_name, new_resource
      end
    else
      Chef::Log.debug('downloading tarball from an unofficial repository')
      remote_file "#{node['java']['download_path']}/#{tarball_name}" do
        source new_resource.url
        checksum new_resource.checksum
        retries new_resource.retries
        retry_delay new_resource.retry_delay
        mode '0755'
        action :nothing
      end.run_action(:create_if_missing)
    end

    converge_by("extract compressed data into Chef file cache path and move extracted data to #{app_dir}") do
      case tarball_name
      when /^.*\.bin/
        cmd = shell_out(
          %(cd "#{node['java']['download_path']}";
              bash ./#{tarball_name} -noregister
            )
        )
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
        end
      when /^.*\.zip/
        cmd = shell_out(
          %(unzip "#{node['java']['download_path']}/#{tarball_name}" -d "#{node['java']['download_path']}" )
        )
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
        end
      when /^.*\.(tar.gz|tgz)/
        package 'tar' do
          not_if { platform_family?('mac_os_x', 'windows') }
          action :nothing
        end.run_action(:install)

        cmd = shell_out(
          %(tar xvzf "#{node['java']['download_path']}/#{tarball_name}" -C "#{node['java']['download_path']}" --no-same-owner)
        )
        unless cmd.exitstatus == 0
          Chef::Application.fatal!("Failed to extract file #{tarball_name}!")
        end
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
  java_name =  app_home.split('/')[-1]
  jinfo_file = "#{app_root}/.#{java_name}.jinfo"
  if platform_family?('debian') && !::File.exist?(jinfo_file)
    converge_by("Add #{jinfo_file} for debian") do
      template jinfo_file do
        cookbook 'java'
        source 'oracle.jinfo.erb'
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
  app_dir_name, _tarball_name = parse_app_dir_name(new_resource.url)
  app_root = new_resource.app_home.split('/')[0..-2].join('/')
  app_dir = app_root + '/' + app_dir_name

  if new_resource.default
    app_home = new_resource.app_home
  else
    Chef::Log.debug('processing alternate jdk')
    app_dir += '_alt'
    app_home = new_resource.app_home + '_alt'
  end

  if ::File.exist?(app_dir)
    java_alternatives 'unset-java-alternatives' do
      java_location app_home
      bin_cmds new_resource.bin_cmds
      action :unset
    end

    converge_by("remove #{new_resource.name} at #{app_dir}") do
      Chef::Log.info "Removing #{new_resource.name} at #{app_dir}"
      FileUtils.rm_rf app_dir
    end
  end
end

action_class do
  require 'uri'

  def parse_app_dir_name(url)
    uri = URI.parse(url)
    file_name = uri.path.split('/').last
    # funky logic to parse oracle's non-standard naming convention
    # for jdk1.6 -> 1.9, 10.0.0->10.0.2, 11
    if file_name =~ /^(jre|jdk|server-jre).*$/
      major_num = file_name.scan(/\d{1,}/)[0]
      package_name = file_name =~ /^server-jre.*$/ ? 'jdk' : file_name.scan(/[a-z]+/)[0]
      if major_num.to_i >= 10
        # Versions 10 and above incorporate semantic versioning and/or single version numbers
        version_result = file_name.scan(/.*-([\d\.]+)_.*/)[0][0]
        app_dir_name = "#{package_name}-#{version_result}"
      else
        update_token = file_name.scan(/u(\d+)/)[0]
        update_num = update_token ? update_token[0] : '0'
        # pad a single digit number with a zero
        update_num = '0' + update_num if update_num.length < 2
        app_dir_name = if update_num == '00'
                         "#{package_name}1.#{major_num}.0"
                       else
                         "#{package_name}1.#{major_num}.0_#{update_num}"
                       end
      end
    else
      app_dir_name = file_name.split(/(.tgz|.tar.gz|.zip)/)[0]
      app_dir_name = app_dir_name.split('-bin')[0]
    end
    [app_dir_name, file_name]
  end

  def oracle_downloaded?(download_path, new_resource)
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

  def download_direct_from_oracle(tarball_name, new_resource)
    download_path = "#{node['java']['download_path']}/#{tarball_name}"
    cookie = 'oraclelicense=accept-securebackup-cookie'
    proxy = "-x #{new_resource.proxy}" unless new_resource.proxy.nil?
    if new_resource.accept_oracle_download_terms
      # install the curl package
      package 'curl' do
        action :nothing
      end.run_action(:install)

      converge_by('download oracle tarball straight from the server') do
        Chef::Log.debug 'downloading oracle tarball straight from the source'
        shell_out!(
          %W(
            curl
            --fail
            --create-dirs
            -L
            --retry #{new_resource.retries}
            --retry-delay #{new_resource.retry_delay} --cookie "#{cookie}"
            #{new_resource.url}
            -o #{download_path}
            --connect-timeout #{new_resource.connect_timeout}
            #{proxy}
          ).join(' '),
          timeout: new_resource.download_timeout
        )
      end
      # Can't verify anything with HTTP return codes from Oracle. For example, they return 200 for auth failure.
      # Do a generic verification of the download
      unless oracle_downloaded?(download_path, new_resource)
        Chef::Application.fatal!("Checksum verification failure. Possible wrong checksum or download from Oracle failed.\nVerify artifact checksum and/or verify #{download_path} is an archive and not an HTML response from Oracle")
      end
    else
      Chef::Application.fatal!("You must set the resource property 'accept_oracle_download_terms' or set the node attribute node['java']['oracle']['accept_oracle_download_terms'] to true if you want to download directly from the oracle site!")
    end
  end
end
