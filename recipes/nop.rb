# Author:: Kim Neunert (<kim.neunert@hybris.com>)
#
# Cookbook Name:: java
# Recipe:: nop
#
# Copyright 2014, Kim Neunert <kim.neunert@hybris.com>
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

# This recipe does nothing, it's a way to skip the usage of the cookbook
# entirely without touching the dependency-tree

# Usage:
# Default["java"]["install_flavor"]="nop"


Chef::Application.info("java-cookbook processing skipped because install_flavor==nop ")
