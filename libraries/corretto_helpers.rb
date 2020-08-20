module Java
  module Cookbook
    module CorrettoHelpers
      def corretto_arch
        node['kernel']['machine'].match?('aarch64') ? 'aarch64' : 'x64'
      end

      def default_corretto_url(version)
        if version.to_s == '8'
          "https://corretto.aws/downloads/latest/amazon-corretto-8-#{corretto_arch}-linux-jdk.tar.gz"
        elsif version.to_s == '11'
          "https://corretto.aws/downloads/latest/amazon-corretto-11-#{corretto_arch}-linux-jdk.tar.gz"
        end
      end

      def default_corretto_checksum(version)
        if version.to_s == '8'
          if node['kernel']['machine'].match?('x86_64')
            '1db9c4bd89b9949c97bc5e690aedce2872bb716cf35c670a29cadeeb80d0cb18'
          elsif node['kernel']['machine'].match?('aarch64')
            '2e3755bac052ad7c502adbaec7823328644af3767abd1169974b144805eb718e'
          end
        elsif version.to_s == '11'
          if node['kernel']['machine'].match?('x86_64')
            'dbbf98ca93b44a0c81df5a3a4f2cebf467ec5c30e28c359e26615ffbed0b454f'
          elsif node['kernel']['machine'].match?('aarch64')
            'f278647d126d973a841d80b0b6836b723f14c63ee0d0f1804b8d4125843b13ed'
          end
        end
      end

      def default_corretto_bin_cmds(version)
        if version.to_s == '8'
          %w(appletviewer clhsdb extcheck hsdb idlj jar jarsigner java java-rmi.cgi javac javadoc javafxpackager javah javap javapackager jcmd jconsole jdb jdeps jfr jhat jinfo jjs jmap jps jrunscript jsadebugd jstack jstat jstatd keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        elsif version.to_s == '11'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        end
      end

      def corretto_sub_dir(version, full_version = nil)
        ver = if version == '8'
                full_version || '8.265.01.1'
              elsif version.to_s == '11'
                full_version || '11.0.8.10.1'
              end
        "amazon-corretto-#{ver}-linux-#{corretto_arch}"
      end
    end
  end
end
