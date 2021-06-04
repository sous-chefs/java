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
