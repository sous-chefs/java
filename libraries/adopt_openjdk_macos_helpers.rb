module Java
  module Cookbook
    module AdoptOpenJdkMacOsHelpers
      def macos_java_home(version)
        if version.include? 'jre'
          ending = '.jre'
          version.gsub!('-jre', '')
        else
          ending = '.jdk'
        end

        version.gsub!('jdk', 'jdk-')
        version.slice!('-large')

        "/Library/Java/JavaVirtualMachines/#{version}#{ending}/Contents/Home"
      end
    end
  end
end
