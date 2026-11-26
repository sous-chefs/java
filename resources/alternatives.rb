# frozen_string_literal: true

provides :java_alternatives
unified_mode true

property :java_location,
          String,
          description: 'Java installation location'

property :bin_cmds,
          Array,
          callbacks: {
            'must contain only command names' => lambda { |cmds|
              cmds.all? { |cmd| cmd.match?(/\A[A-Za-z0-9_.+-]+\z/) }
            },
          },
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
  set_alternatives(bin_cmds_to_setup) do |cmd, alt_path|
    alternative_exists = ::File.exist?(alternative_file_path(cmd)) &&
                         alternatives_display(cmd).stdout.include?(alt_path)
    Chef::Log.debug("Alternative for #{cmd} exists with correct path? #{alternative_exists}")
    alternative_exists
  end
end

action :unset do
  new_resource.bin_cmds.each do |cmd|
    converge_by("Remove alternative for #{cmd}") do
      shell_out!(alternatives_cmd, '--remove', cmd, "#{new_resource.java_location}/bin/#{cmd}")
    end
  end
end

action_class do
  def alternatives_cmd
    platform_family?('rhel', 'fedora', 'amazon') ? 'alternatives' : 'update-alternatives'
  end

  def alternatives_display(cmd)
    shell_out(alternatives_cmd, '--display', cmd)
  end

  def alternative_file_path(cmd)
    if platform_family?('debian')
      "/var/lib/dpkg/alternatives/#{cmd}"
    else
      "/var/lib/alternatives/#{cmd}"
    end
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

      bin_cmds_to_setup << [cmd, bin_path, alt_path, priority]
    end
    bin_cmds_to_setup
  end

  def set_alternatives(bin_cmds)
    bin_cmds.each do |cmd, bin_path, alt_path, priority|
      if block_given? && yield(cmd, alt_path)
        Chef::Log.debug "Skipping alternative for #{cmd} as it already exists with correct path"
        next
      end

      display_result = alternatives_display(cmd)
      cmd_output = display_result.stdout

      alternative_system_exists = display_result.exitstatus == 0 && !cmd_output.empty?
      our_alternative_exists = alternative_system_exists && cmd_output.include?(alt_path)

      existing_priority = nil
      if our_alternative_exists
        if cmd_output =~ /#{Regexp.escape(alt_path)}.*priority\s+(\d+)/
          existing_priority = Regexp.last_match(1).to_i
        end
      end

      if our_alternative_exists && existing_priority && existing_priority != priority
        converge_by("Removing alternative for #{cmd} with old priority #{existing_priority}") do
          shell_out!(alternatives_cmd, '--remove', cmd, alt_path)
        end
      end

      alternative_file_exists = ::File.exist?(alternative_file_path(cmd))

      if !our_alternative_exists || !alternative_file_exists
        converge_by("Add alternative for #{cmd}") do
          if new_resource.reset_alternatives && alternative_file_exists
            ::FileUtils.rm_f(alternative_file_path(cmd))
          end
          shell_out!(alternatives_cmd, '--install', bin_path, cmd, alt_path, priority.to_s)
        end
      end

      next unless new_resource.default
      alternative_is_set = alternatives_display(cmd).stdout.include?("link currently points to #{alt_path}")
      next if alternative_is_set
      converge_by("Set alternative for #{cmd}") do
        Chef::Log.debug "Setting alternative for #{cmd}"
        shell_out!(alternatives_cmd, '--set', cmd, alt_path)
      end
    end
  end
end
