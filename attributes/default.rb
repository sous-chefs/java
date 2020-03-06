#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: java
# Attributes:: default
#
# Copyright:: 2010-2015, Chef Software, Inc.
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

case node['platform_family']
when 'windows'
  default['java']['install_flavor'] = 'windows'
  default['java']['windows']['url'] = nil
  default['java']['windows']['checksum'] = nil
  default['java']['windows']['package_name'] = 'Java(TM) SE Development Kit 7 (64-bit)'
  default['java']['windows']['public_jre_home'] = nil
  default['java']['windows']['owner'] = 'administrator'
  default['java']['windows']['remove_obsolete'] = false
  default['java']['windows']['returns'] = 0
when 'mac_os_x'
  default['java']['install_flavor'] = 'homebrew'
  default['java']['homebrew']['cask'] = 'java'
  # else
  #   Chef::Log.info('The default recipe is no longer recommended. Please use the install resources instead')
end

# S390(X) - IBM zSeries Architecture - only IBM jre / jdk can be used. Download from https://developer.ibm.com/javasdk/downloads/
if node['kernel']['machine'].start_with?('s390')
  default['java']['install_flavor'] = 'ibm'
end

default['java']['ibm']['url'] = nil
default['java']['ibm']['checksum'] = nil
default['java']['ibm']['accept_ibm_download_terms'] = false

default['java']['ibm']['6']['bin_cmds'] = %w(appletviewer apt ControlPanel extcheck HtmlConverter idlj jar jarsigner
                                             java javac javadoc javah javap javaws jconsole jcontrol jdb jdmpview
                                             jrunscript keytool native2ascii policytool rmic rmid rmiregistry
                                             schemagen serialver tnameserv wsgen wsimport xjc)

default['java']['ibm']['7']['bin_cmds'] = node['java']['ibm']['6']['bin_cmds'] + %w(pack200 unpack200)
default['java']['ibm']['8']['bin_cmds'] = node['java']['ibm']['7']['bin_cmds']

# type of java RPM : jdk or jre
default['java']['oracle_rpm']['type'] = 'jdk'

# optional, can be overriden to pin to a version different
# from the up-to-date.
default['java']['oracle_rpm']['package_version'] = nil

# optional, some distros re-package the official Oracle's RPM
# with a different name
default['java']['oracle_rpm']['package_name'] = nil

# if you change this to true, you can download directly from Oracle
default['java']['oracle']['accept_oracle_download_terms'] = false
