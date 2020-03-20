module Java
  module Cookbook
    module CorrettoHelpers
      def default_corretto_url(version)
        if version.to_s == '8'
          'https://corretto.aws/downloads/latest/amazon-corretto-8-x64-linux-jdk.tar.gz'
        else
          'https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz'
        end
      end

      def default_corretto_checksum(version)
        if version.to_s == '8'
          'e302fbd2d7354a2a8c5fa7491f4de1d73967104078da9671abada260b2f02fcd'
        else
          'ceb676297a169c0f38bc3807fba9769f3a97ddf1e7522b92b85e97e11c35d3f4'
        end
      end

      def default_corretto_bin_cmds(version)
        if version.to_s == '8'
          ['appletviewer', 'clhsdb', 'extcheck', 'hsdb', 'idlj', 'jar', 'jarsigner', 'java', 'java-rmi.cgi', 'javac', 'javadoc', 'javafxpackager', 'javah', 'javap', 'javapackager', 'jcmd', 'jconsole', 'jdb', 'jdeps', 'jhat', 'jinfo', 'jjs', 'jmap', 'jps', 'jrunscript', 'jsadebugd', 'jstack', 'jstat', 'jstatd', 'keytool', 'native2ascii', 'orbd', 'pack200', 'policytool', 'rmic', 'rmid', 'rmiregistry', 'schemagen', 'serialver', 'servertool', 'tnameserv', 'unpack200', 'wsgen', 'wsimport', 'xjc']
        else
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        end
      end

      def corretto_sub_dir(version, full_version = nil)
        ver = if version == '8'
                full_version || '8.242.08.1'
              else
                full_version || '11.0.6.10.1'
              end

        "amazon-corretto-#{ver}-linux-x64"
      end
    end
  end
end
