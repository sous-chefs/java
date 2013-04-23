#
# Author:: Kendrick Martin (<kendrick.martin@webtrends.com>)
# Cookbook Name:: java
# Recipe:: windows
#
# Copyright 2008-2012 Webtrends, Inc.
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
#

Chef::Log.warn("No download url set for java installer.") unless node['java']['windows']['url']

unless node['java']['java_home'].nil? || node['java']['java_home'].empty?
  java_home_win = win_friendly_path(node['java']['java_home'])
  additional_options = "INSTALLDIR=#{java_home_win}"
end

  
windows_package node['java']['windows']['package_name'] do
  source node['java']['windows']['url']
  checksum node['java']['windows']['checksum'] unless node['java']['windows']['checksum'].empty? 
  action :install
  installer_type :custom
  options "/s #{additional_options}"
end

unless node['java']['java_home'].nil? || node['java']['java_home'].empty?
  env "JAVA_HOME" do
    value java_home_win
  end
  
  # update path
  windows_path node['java']['java_home'] do
    action :add
  end 
end
