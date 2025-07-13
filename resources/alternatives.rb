unified_mode true

property :java_location,
          String,
          description: 'Java installation location'

property :bin_cmds,
          Array,
          description: 'Array of Java tool names to set or unset alternatives on'

property :default,
          [true, false],
          default: true,
          description: 'Whether to set the Java tools as system default. Boolean, defaults to `true`'

property :priority,
          Integer,
          default: 1061,
          description: ' Priority of the alternatives. Integer, defaults to `1061`'

property :reset_alternatives,
          [true, false],
          default: false,
          description: 'Whether to reset alternatives before setting them'

action :set do
  bin_cmds_to_setup = parse_java_alternatives
  # Use not_if guard to make resource fully idempotent
  set_alternatives(bin_cmds_to_setup) do |cmd, alt_path|
    # Skip if the alternative file already exists with our path
    alternative_exists = ::File.exist?("/var/lib/alternatives/#{cmd}") &&
                         shell_out("#{alternatives_cmd} --display #{cmd}").stdout.include?(alt_path)
    Chef::Log.debug("Alternative for #{cmd} exists with correct path? #{alternative_exists}")
    alternative_exists
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

  def parse_java_alternatives
    bin_cmds_to_setup = []
    new_resource.bin_cmds.each do |cmd|
      bin_path = "/usr/bin/#{cmd}"
      alt_path = "#{new_resource.java_location}/bin/#{cmd}"
      priority = new_resource.priority

      unless ::File.exist?(alt_path)
        Chef::Log.debug "Skipping setting alternative for #{cmd}. Command #{alt_path} does not exist."
        next
      end

      # Add this command to the list of commands to process
      bin_cmds_to_setup << [cmd, bin_path, alt_path, priority]
    end
    bin_cmds_to_setup
  end

  def set_alternatives(bin_cmds)
    bin_cmds.each do |cmd, bin_path, alt_path, priority|
      # Use a custom not_if condition if provided as a block
      if block_given? && yield(cmd, alt_path)
        Chef::Log.debug "Skipping alternative for #{cmd} as it already exists with correct path"
        next
      end

      # Get the full output of update-alternatives for this command
      display_result = shell_out("#{alternatives_cmd} --display #{cmd}")
      cmd_output = display_result.stdout

      # Check if the alternative exists at all
      alternative_system_exists = display_result.exitstatus == 0 && !cmd_output.empty?

      # Check if our specific path is already configured as an alternative
      our_alternative_exists = alternative_system_exists && cmd_output.include?(alt_path)

      # Parse the priority of the existing alternative
      existing_priority = nil
      if our_alternative_exists
        if cmd_output =~ /#{Regexp.escape(alt_path)}.*priority\s+(\d+)/
          existing_priority = Regexp.last_match(1).to_i
        end
      end

      # Only remove alternative if it exists with a different priority
      if our_alternative_exists && existing_priority && existing_priority != priority
        converge_by("Removing alternative for #{cmd} with old priority #{existing_priority}") do
          remove_cmd = shell_out("#{alternatives_cmd} --remove #{cmd} #{alt_path}")
          unless remove_cmd.exitstatus == 0
            raise(%( remove alternative failed ))
          end
        end
      end

      # Check if the alternative file exists at all
      alternative_file_exists = ::File.exist?("/var/lib/alternatives/#{cmd}")

      # Install the alternative if needed
      if !our_alternative_exists || !alternative_file_exists
        converge_by("Add alternative for #{cmd}") do
          if new_resource.reset_alternatives && alternative_file_exists
            shell_out("rm /var/lib/alternatives/#{cmd}")
          end
          install_cmd = shell_out("#{alternatives_cmd} --install #{bin_path} #{cmd} #{alt_path} #{priority}")
          unless install_cmd.exitstatus == 0
            raise(%( install alternative failed ))
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
          raise(%( set alternative failed ))
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
