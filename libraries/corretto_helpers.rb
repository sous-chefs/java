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
        elsif version.to_s == '15'
          "https://corretto.aws/downloads/latest/amazon-corretto-15-#{corretto_arch}-linux-jdk.tar.gz"
        end
      end

      def default_corretto_checksum(version)
        if version.to_s == '8'
          if node['kernel']['machine'].match?('x86_64')
            '5db96ea7c5fa34de4eadbc41e2adf1fccb7e373b5788f77e26e0d69b9e368b7f'
          elsif node['kernel']['machine'].match?('aarch64')
            '124875d5d2b3b540d40a584605385c03e71bf57f782baf5130e0bfee18b680c1'
          end
        elsif version.to_s == '11'
          if node['kernel']['machine'].match?('x86_64')
            'bf9380ee0cdd78fafb6d0cdfa0c1a97baaaec44432a15c8c2f296696ad9ed631'
          elsif node['kernel']['machine'].match?('aarch64')
            '18f4716151f4786abe6b185aab2cc5f5ad7b15f899d7eb143a81ccda8690f6f6'
          end
        elsif version.to_s == '15'
          if node['kernel']['machine'].match?('x86_64')
            '6bd07d74e11deeba9f8927f8353aa689ffaa2ada263b09a4c297c0c58887af0f'
          elsif node['kernel']['machine'].match?('aarch64')
            'e5112fec0f4e6f3de048c5bd6a9a690dd07344436985755636df6dc18b4bfb62'
          end
        end
      end

      def default_corretto_bin_cmds(version)
        if version.to_s == '8'
          %w(appletviewer clhsdb extcheck hsdb idlj jar jarsigner java java-rmi.cgi javac javadoc javafxpackager javah javap javapackager jcmd jconsole jdb jdeps jfr jhat jinfo jjs jmap jps jrunscript jsadebugd jstack jstat jstatd keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        elsif version.to_s == '11'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        elsif version.to_s == '15'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jlink jmap jmod jpackage jps jrunscript jshell jstack jstat jstatd keytool rmid rmiregistry serialver)
        end
      end

      def corretto_sub_dir(version, full_version = nil)
        ver = if version == '8'
                full_version || '8.282.08.1'
              elsif version.to_s == '11'
                full_version || '11.0.10.9.1'
              elsif version.to_s == '15'
                full_version || '15.0.1.9.1'
              end
        "amazon-corretto-#{ver}-linux-#{corretto_arch}"
      end
    end
  end
end
