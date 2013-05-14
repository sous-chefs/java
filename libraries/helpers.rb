#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2013, Opscode, Inc. <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/version_constraint'
require 'uri'

module Opscode
  class OpenJDK

    attr_accessor :java_home, :jdk_version

    def initialize(node)
      @node = node.to_hash
      @java_home = @node['java']['java_home'] || '/usr/lib/jvm'
      @jdk_version = @node['java']['jdk_version'] || '6'
    end

    def java_location
      File.join(@java_home, openjdk_path, 'bin/java')
    end

    def openjdk_path
      case @node['platform_family']
      when 'debian'
        'java-%s-openjdk%s/jre' % [@jdk_version, arch_dir]
      when 'rhel'
        'jre-1.%s.0-openjdk%s' % [@jdk_version, arch_dir]
      end
    end

    def arch_dir
      @node['kernel']['machine'] == 'x86_64' ? sixty_four : thirty_two
    end

    def sixty_four
      case @node['platform_family']
      when 'debian'
        '-amd64'
      when 'rhel'
        '.x86_64'
      else
        '-x86_64'
      end
    end

    def thirty_two
      case @node['platform_family']
      when 'debian'
        old_version? ? '' : '-i386'
      else
        ''
      end
    end

    def old_version?
      case @node['platform']
      when 'ubuntu'
        Chef::VersionConstraint.new("< 11.0").include?(@node['platform_version'])
      when 'debian'
        Chef::VersionConstraint.new("< 7.0").include?(@node['platform_version'])
      end
    end
  end
end

class Chef
  class Recipe
    def valid_ibm_jdk_uri?(url)
      url =~ ::URI::ABS_URI && %w[http https].include?(::URI.parse(url).scheme)
    end
  end
end
