module Java
  module Cookbook
    module CertificateHelpers
      def default_truststore_path(version, java_home)
        if version.to_i > 8
          "#{java_home}/lib/security/cacerts"
        else
          "#{java_home}/jre/lib/security/cacerts"
        end
      end

      def keystore_argument(version, cacerts, truststore_path)
        if version.to_i > 8 && cacerts
          '-cacerts'
        else
          "-keystore #{truststore_path}"
        end
      end
    end
  end
end
