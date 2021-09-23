module Java
  module Cookbook
    module CorrettoHelpers
      def corretto_arch
        node['kernel']['machine'].match?('aarch64') ? 'aarch64' : 'x64'
      end

      def default_corretto_url(version)
        case version.to_s
        when '8'
          "https://corretto.aws/downloads/latest/amazon-corretto-8-#{corretto_arch}-linux-jdk.tar.gz"
        when '11'
          "https://corretto.aws/downloads/latest/amazon-corretto-11-#{corretto_arch}-linux-jdk.tar.gz"
        when '15'
          "https://corretto.aws/downloads/latest/amazon-corretto-15-#{corretto_arch}-linux-jdk.tar.gz"
        when '16'
          "https://corretto.aws/downloads/latest/amazon-corretto-16-#{corretto_arch}-linux-jdk.tar.gz"
        else
          raise 'Correcto version not recognised'
        end
      end

      def default_corretto_bin_cmds(version)
        case version.to_s
        when '8'
          %w(appletviewer clhsdb extcheck hsdb idlj jar jarsigner java java-rmi.cgi javac javadoc javafxpackager javah javap javapackager jcmd jconsole jdb jdeps jfr jhat jinfo jjs jmap jps jrunscript jsadebugd jstack jstat jstatd keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '11'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        when '15'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jlink jmap jmod jpackage jps jrunscript jshell jstack jstat jstatd keytool rmid rmiregistry serialver)
        when '16'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jlink jmap jmod jpackage jps jrunscript jshell jstack jstat jstatd keytool rmid rmiregistry serialver)
        else
          raise 'Correcto version not recognised'
        end
      end

      def corretto_sub_dir(version, full_version = nil)
        case version
        when '8'
          ver = full_version || '8.302.08.1'
        when '11'
          ver = full_version || '11.0.12.7.1'
        when '15'
          ver = full_version || '15.0.2.7.1'
        when '16'
          ver = full_version || '16.0.2.7.1'
        else
          raise 'Correcto version not recognised'
        end

        "amazon-corretto-#{ver}-linux-#{corretto_arch}"
      end
    end
  end
end
