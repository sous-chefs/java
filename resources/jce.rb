#
# Cookbook:: java
# Provider:: jce
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

property :jdk_version, String, default: lazy { node['java']['jdk_version'].to_s }
property :jce_url, String, default: lazy { node['java']['oracle']['jce'][jdk_version]['url'] }
property :jce_checksum, String, default: lazy { node['java']['oracle']['jce'][jdk_version]['checksum'] }
property :java_home, String, default: lazy { node['java']['java_home'] }
property :jce_home, String, default: lazy { node['java']['oracle']['jce']['home'] }
property :jce_cookie, String, default: lazy { node['java']['oracle']['accept_oracle_download_terms'] ? 'oraclelicense=accept-securebackup-cookie' : '' }
property :principal, String, default: lazy { platform_family?('windows') ? node['java']['windows']['owner'] : 'administrator' }

action :install do
  jdk_version = new_resource.jdk_version
  jce_url = new_resource.jce_url
  jce_checksum = new_resource.jce_checksum
  java_home = new_resource.java_home
  jce_home = new_resource.jce_home
  jce_cookie = new_resource.jce_cookie
  principal = new_resource.principal

  directory ::File.join(jce_home, jdk_version) do
    mode '0755'
    recursive true
  end

  r = remote_file "#{Chef::Config[:file_cache_path]}/jce.zip" do
    source jce_url
    checksum jce_checksum
    headers(
      'Cookie' => jce_cookie
    )
    not_if { ::File.exist?(::File.join(jce_home, jdk_version, 'US_export_policy.jar')) }
  end

  if node['os'] == 'windows'
    include_recipe 'windows'

    staging_path = ::File.join(jce_home, jdk_version)
    staging_local_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'local_policy.jar')
    staging_export_policy = ::File.join(staging_path, "UnlimitedJCEPolicyJDK#{jdk_version}", 'US_export_policy.jar')
    jre_final_path = ::File.join(java_home, 'jre', 'lib', 'security')
    final_local_policy = ::File.join(jre_final_path, 'local_policy.jar')
    final_export_policy = ::File.join(jre_final_path, 'US_export_policy.jar')

    windows_zipfile staging_path do
      source r.path
      checksum jce_checksum
      action :unzip
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
    package 'curl'

    execute 'extract jce' do
      command <<-EOF
        rm -rf java_jce
        mkdir java_jce
        cd java_jce
        unzip -o ../jce.zip
        find -name '*.jar' | xargs -I JCE_JAR mv JCE_JAR #{jce_home}/#{jdk_version}/
        chmod -R 0644 #{jce_home}/#{jdk_version}/*.jar
      EOF
      cwd Chef::Config[:file_cache_path]
      creates ::File.join(jce_home, jdk_version, 'US_export_policy.jar')
    end

    %w(local_policy.jar US_export_policy.jar).each do |jar|
      jar_path = ::File.join(java_home, 'jre', 'lib', 'security', jar)
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
