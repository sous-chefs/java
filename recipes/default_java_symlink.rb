# Cookbook Name:: java
# Recipe:: default_java_symlink
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
require 'pathname'

default = '/usr/lib/jvm/default-java'

home = node['java']['java_home']

home_obj = Pathname.new(home) # compare path objects not strings

target = Pathname.new(default).realpath
# does not work, just returns the relative path in debian :
#    target = File.readlink(default)

Chef::Log.debug "Java Home #{default} resolves to #{target} wanted is #{home}"

if target != home_obj
  Chef::Log.debug "Check #{home} != #{target}"
  link default do
    to home
  end
end
