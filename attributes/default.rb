#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

# remove the deprecated Ubuntu jdk packages
default['java']['remove_deprecated_packages'] = false

# default jdk attributes
default['java']['install_flavor'] = "openjdk"
default['java']['jdk_version'] = '6'
default['java']['arch'] = kernel['machine'] =~ /x86_64/ ? "x86_64" : "i586"

case platform
when "centos","redhat","fedora","scientific","amazon"
  default['java']['java_home'] = "/usr/lib/jvm/java"
when "freebsd"
  default['java']['java_home'] = "/usr/local/openjdk#{java['jdk_version']}"
when "arch"
  default['java']['java_home'] = "/usr/lib/jvm/java-#{java['jdk_version']}-openjdk"
else
  default['java']['java_home'] = "/usr/lib/jvm/default-java"
end

# If you change this to true, you can download directly from Oracle
default['java']['oracle']['accept_oracle_download_terms'] = false

# direct download paths for oracle, u been warned!

# jdk6 attributes
# x86_64
default['java']['jdk']['6']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u33-b04/jdk-6u33-linux-x64.bin'
default['java']['jdk']['6']['x86_64']['checksum'] = '215e38e49f7b1b8f0b66383598a51125dbaf04dbcc79de14732406df5e342fb9'

# i586
default['java']['jdk']['6']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/6u33-b04/jdk-6u33-linux-i586.bin'
default['java']['jdk']['6']['i586']['checksum'] = 'bfb8f04ea18eb39a0e476b400a506d2614a3ce258d09a87d25e401e0f9b4d940'

# jdk7 attributes
# x86_64
default['java']['jdk']['7']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u5-b06/jdk-7u5-linux-x64.tar.gz'
default['java']['jdk']['7']['x86_64']['checksum'] = 'aaf0296f08007cb178ff45dea61125aedb8af0450f82e0f2fd51df5391c9e837'

# i586
default['java']['jdk']['7']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/7u5-b06/jdk-7u5-linux-i586.tar.gz'
default['java']['jdk']['7']['i586']['checksum'] = '422dfe67a4885d47c0053b97f4a56fb4dced60799a1bb82f8266b0745a7149f7'
