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
            '25415701c864ec301975097f207e909d065eb7c452a501c0e4b4487e77fbdc7a'
          elsif node['kernel']['machine'].match?('aarch64')
            '7b86c40410c75de44c311fe127bb1dd02c43040312d66b1363737ab3e7d77011'
          end
        elsif version.to_s == '11'
          if node['kernel']['machine'].match?('x86_64')
            '448494766be37bb8a4ecd983a09742d28b1fa426684417b0dec2f3b03c44f3a3'
          elsif node['kernel']['machine'].match?('aarch64')
            'e25669eb74d6c270af303bc0d1d859dd9ff16a0288f00a9d0ba4105467fc9695'
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
                full_version || '8.275.01.1'
              elsif version.to_s == '11'
                full_version || '11.0.9.12.1'
              elsif version.to_s == '15'
                full_version || '15.0.1.9.1'
              end
        "amazon-corretto-#{ver}-linux-#{corretto_arch}"
      end
    end
  end
end
