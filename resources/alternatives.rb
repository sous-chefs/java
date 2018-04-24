#
# Cookbook:: java
# Provider:: alternatives
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

property :java_location, String
property :bin_cmds, Array
property :default, [true, false], default: true
property :priority, Integer, default: 1061
property :reset_alternatives, [true, false], default: true

action :set do
  if new_resource.bin_cmds
    new_resource.bin_cmds.each do |cmd|
      bin_path = "/usr/bin/#{cmd}"
      alt_path = "#{new_resource.java_location}/bin/#{cmd}"
      priority = new_resource.priority

      unless ::File.exist?(alt_path)
        Chef::Log.debug "Skipping setting alternative for #{cmd}. Command #{alt_path} does not exist."
        next
      end

      alternative_exists_same_priority = shell_out("#{alternatives_cmd} --display #{cmd} | grep #{alt_path} | grep 'priority #{priority}$'").exitstatus == 0
      alternative_exists = shell_out("#{alternatives_cmd} --display #{cmd} | grep #{alt_path}").exitstatus == 0
      # remove alternative if priority is changed and install it with new priority
      if alternative_exists && !alternative_exists_same_priority
        converge_by("Removing alternative for #{cmd} with old priority") do
          Chef::Log.debug "Removing alternative for #{cmd} with old priority"
          remove_cmd = shell_out("#{alternatives_cmd} --remove #{cmd} #{alt_path}")
          alternative_exists = false
          unless remove_cmd.exitstatus == 0
            Chef::Application.fatal!(%( remove alternative failed ))
          end
        end
      end
      # install the alternative if needed
      unless alternative_exists
        converge_by("Add alternative for #{cmd}") do
          Chef::Log.debug "Adding alternative for #{cmd}"
          if new_resource.reset_alternatives
            shell_out("rm /var/lib/alternatives/#{cmd}")
          end
          install_cmd = shell_out("#{alternatives_cmd} --install #{bin_path} #{cmd} #{alt_path} #{priority}")
          unless install_cmd.exitstatus == 0
            Chef::Application.fatal!(%( install alternative failed ))
          end
        end
      end

      # set the alternative if default
      next unless new_resource.default
      alternative_is_set = shell_out("#{alternatives_cmd} --display #{cmd} | grep \"link currently points to #{alt_path}\"").exitstatus == 0
      next if alternative_is_set
      converge_by("Set alternative for #{cmd}") do
        Chef::Log.debug "Setting alternative for #{cmd}"
        set_cmd = shell_out("#{alternatives_cmd} --set #{cmd} #{alt_path}")
        unless set_cmd.exitstatus == 0
          Chef::Application.fatal!(%( set alternative failed ))
        end
      end
    end
  end
end

action :unset do
  new_resource.bin_cmds.each do |cmd|
    converge_by("Remove alternative for #{cmd}") do
      shell_out("#{alternatives_cmd} --remove #{cmd} #{new_resource.java_location}/bin/#{cmd}")
    end
  end
end

action_class do
  def alternatives_cmd
    platform_family?('rhel', 'fedora', 'amazon') ? 'alternatives' : 'update-alternatives'
  end
end
