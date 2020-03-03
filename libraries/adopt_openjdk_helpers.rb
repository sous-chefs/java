module Java
  module Cookbook
    module Helpers
      def sub_dir(url)
        uri = URI.parse(url)
        file_name = uri.path.split('/')[-2]

        result = if file_name =~ /jdk8+/
                   file_name.split('_').first
                 else
                   file_name.split('_').first.gsub('%2B', '+')
                 end

        Chef::Application.fatal!("Failed to parse #{file_name} for directory name!") if result.empty?

        result
      end
    end
  end
end
