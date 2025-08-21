module Java
  module Cookbook
    module CertificateHelpers
      def default_truststore_path(version, java_home)
        if version.to_i > 8
          "#{java_home}/lib/security/cacerts"
        else
          Chef::Log.fatal('Java 8 is no longer supported')
          raise 'Java 8 is no longer supported'
        end
      end

      def keystore_argument(cacerts, truststore_path)
        cacerts ? '-cacerts' : "-keystore #{truststore_path}"
      end
    end
  end
end
