# frozen_string_literal: true

provides :java_jce
unified_mode true

property :jdk_version,
          String,
          name_property: true, description: 'The Java version to install into'

property :jce_url,
          String,
          required: true, description: 'The URL for the JCE distribution'

property :jce_checksum,
          String,
          required: true, description: 'The checksum of the JCE distribution'

property :java_home,
          String,
          required: true, description: 'The location of the Java installation'

property :jce_home,
          String,
          default: '/usr/lib/jvm/jce', description: 'The location where JCE files will be decompressed for installation'

property :jce_cookie,
          String,
          default: '', description: 'Indicates that you accept Oracles EULA'

property :principal,
          String,
          default: 'administrator', description: 'For Windows installations only, this determines the owner of the JCE files'

property :download_path,
          String,
          default: Chef::Config[:file_cache_path], description: 'Path used to stage the JCE archive'

property :install_type,
          String,
          equal_to: %w(jdk jre),
          default: 'jdk', description: 'Whether the Java install is a jdk or jre layout'

action :install do
  jdk_version = new_resource.jdk_version
  jce_url = new_resource.jce_url
  jce_checksum = new_resource.jce_checksum
  java_home = new_resource.java_home
  jce_home = new_resource.jce_home
  jce_cookie = new_resource.jce_cookie
  principal = new_resource.principal
  download_path = new_resource.download_path
  install_type = new_resource.install_type

  directory ::File.join(jce_home, jdk_version) do
    mode '0755'
    recursive true
  end

  directory download_path do
    mode '0755'
    recursive true
  end

  r = remote_file ::File.join(download_path, 'jce.zip') do
    source jce_url
    checksum jce_checksum
    headers(
      'Cookie' => jce_cookie
    )
    not_if { ::File.exist?(::File.join(jce_home, jdk_version, 'US_export_policy.jar')) }
  end

  # JRE installation does not have a jre folder
  jre_path = install_type == 'jdk' ? 'jre' : ''

  if platform_family?('windows')

    staging_path = ::File.join(jce_home, jdk_version)
    staging_local_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'local_policy.jar')
    staging_export_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'US_export_policy.jar')
    jre_final_path = ::File.join(java_home, jre_path, 'lib', 'security')
    final_local_policy = ::File.join(jre_final_path, 'local_policy.jar')
    final_export_policy = ::File.join(jre_final_path, 'US_export_policy.jar')

    archive_file staging_path do
      path r.path
      destination staging_path
      action :extract
      not_if { ::File.exist? staging_local_policy }
    end

    remote_file final_local_policy do
      rights :full_control, principal
      source "file://#{staging_local_policy}"
    end

    remote_file final_export_policy do
      rights :full_control, principal
      source "file://#{staging_export_policy}"
    end

  else
    package 'unzip'

    archive_file 'extract jce' do
      path r.path
      destination ::File.join(download_path, 'java_jce')
      overwrite true
      not_if { ::File.exist?(::File.join(jce_home, jdk_version, 'US_export_policy.jar')) }
    end

    ruby_block 'stage jce policy jars' do
      block do
        ::Dir.glob(::File.join(download_path, 'java_jce', '**', '*.jar')).each do |jar|
          destination = ::File.join(jce_home, jdk_version, ::File.basename(jar))
          ::FileUtils.mv(jar, destination)
          ::FileUtils.chmod(0o644, destination)
        end
      end
      not_if { ::File.exist?(::File.join(jce_home, jdk_version, 'US_export_policy.jar')) }
    end

    %w(local_policy.jar US_export_policy.jar).each do |jar|
      jar_path = ::File.join(java_home, jre_path, 'lib', 'security', jar)
      # remove the jars already in the directory
      file jar_path do
        action :delete
        not_if { ::File.symlink? jar_path }
      end
      link jar_path do
        to ::File.join(jce_home, jdk_version, jar)
      end
    end
  end
end

action :remove do
  jdk_version = new_resource.jdk_version
  java_home = new_resource.java_home
  jce_home = new_resource.jce_home
  download_path = new_resource.download_path
  jre_path = new_resource.install_type == 'jdk' ? 'jre' : ''

  %w(local_policy.jar US_export_policy.jar).each do |jar|
    file ::File.join(java_home, jre_path, 'lib', 'security', jar) do
      action :delete
      only_if { ::File.symlink?(path) }
    end
  end

  directory ::File.join(jce_home, jdk_version) do
    recursive true
    action :delete
  end

  directory ::File.join(download_path, 'java_jce') do
    recursive true
    action :delete
  end

  file ::File.join(download_path, 'jce.zip') do
    action :delete
  end
end
