module Java
  module Cookbook
    module CorrettoHelpers
      def corretto_arch
        node['kernel']['machine'].match?('aarch64') ? 'aarch64' : 'x64'
      end

      def default_corretto_url(version)
        "https://corretto.aws/downloads/latest/amazon-corretto-#{version}-#{corretto_arch}-linux-jdk.tar.gz"
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
          raise 'Corretto version not recognised'
        end
      end

      def corretto_sub_dir(version, full_version = nil)
        if full_version.nil?
          case version
          when '8'
            ver = '8.302.08.1'
          when '11'
            ver = '11.0.12.7.1'
          when '15'
            ver = '15.0.2.7.1'
          when '16'
            ver = '16.0.2.7.1'
          else
            raise 'Corretto version not recognised'
          end
        else
          ver = full_version
        end

        "amazon-corretto-#{ver}-linux-#{corretto_arch}"
      end
    end
  end
end
