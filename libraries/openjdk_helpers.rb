module Java
  module Cookbook
    module OpenJdkHelpers
      def lts
        %w(11 17)
      end

      def default_openjdk_install_method(version)
        case node['platform_family']
        when 'amazon'
          'source'
        when 'rhel'
          supported = lts.delete('11')
          supported.include?(version) ? 'package' : 'source'
        when 'debian'
          case node['platform_version']
          when '10', '18.04'
            supported = lts - ['17']
            supported.include?(version) ? 'package' : 'source'
          when '9'
            %w(8).include?(version) ? 'package' : 'source'
          else
            lts.include?(version) ? 'package' : 'source'
          end
        else
          lts.include?(version) ? 'package' : 'source'
        end
      end

      def default_openjdk_url(version)
        case version
        when '9'
          'https://download.java.net/java/GA/jdk9/9/binaries/openjdk-9_linux-x64_bin.tar.gz'
        when '10'
          'https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz'
        when '11'
          'https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz'
        when '12'
          'https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_linux-x64_bin.tar.gz'
        when '13'
          'https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_linux-x64_bin.tar.gz'
        when '14'
          'https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz'
        when '15'
          'https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_linux-x64_bin.tar.gz'
        when '16'
          'https://download.java.net/java/GA/jdk16/7863447f0ab643c585b9bdebf67c69db/36/GPL/openjdk-16_linux-x64_bin.tar.gz'
        when '17'
          'https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
        else
          Chef::Log.fatal('Version specified does not have a URL value set')
          raise 'Version supplied does not have a download URL set'
        end
      end

      def default_openjdk_checksum(version)
        case version
        when '9'
          'f908e31b6185e11b322825809172dcbb7ac0dce64061c9cf154cb1b0df884480'
        when '10'
          'c851df838a51af52517b74e3a4b251d90c54cf478a4ebed99e7285ef134c3435'
        when '11'
          '3784cfc4670f0d4c5482604c7c513beb1a92b005f569df9bf100e8bef6610f2e'
        when '12'
          'b43bc15f4934f6d321170419f2c24451486bc848a2179af5e49d10721438dd56'
        when '13'
          '5f547b8f0ffa7da517223f6f929a5055d749776b1878ccedbd6cc1334f4d6f4d'
        when '14'
          'c7006154dfb8b66328c6475447a396feb0042608ee07a96956547f574a911c09'
        when '15'
          'bb67cadee687d7b486583d03c9850342afea4593be4f436044d785fba9508fb7'
        when '16'
          'e952958f16797ad7dc7cd8b724edd69ec7e0e0434537d80d6b5165193e33b931'
        when '17'
          'aef49cc7aa606de2044302e757fa94c8e144818e93487081c4fd319ca858134b'
        else
          Chef::Log.fatal('Version specified does not have a checksum value set')
          raise 'No checksum value'
        end
      end

      def default_openjdk_bin_cmds(version)
        case version
        when '7'
          %w(appletviewer apt ControlPanel extcheck idlj jar jarsigner java javac javadoc javafxpackager javah javap javaws jcmd jconsole jcontrol jdb jdeps jhat jinfo jjs jmap jmc jps jrunscript jsadebugd jstack jstat jstatd jvisualvm keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '8'
          %w(appletviewer apt ControlPanel extcheck idlj jar jarsigner java javac javadoc javafxpackager javah javap javaws jcmd jconsole jcontrol jdb jdeps jhat jinfo jjs jmap jmc jps jrunscript jsadebugd jstack jstat jstatd jvisualvm keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '9'
          %w(appletviewer idlj jaotc jar jarsigner java javac javadoc javah javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '10'
          %w(appletviewer idlj jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool orbd pack200 rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '11'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        when '12', '13', '14', '15', '16', '17', 'latest'
          %w(jaotc jarsigner javac javap jconsole jdeprscan jfr jimage jjs jmap jps jshell jstat keytool rmic rmiregistry unpack200 jar java javadoc jcmd jdb jdeps jhsdb jinfo jlink jmod jrunscript jstack jstatd pack200 rmid serialver)
        else
          Chef::Log.fatal('Version specified does not have a default set of bin_cmds')
        end
      end

      def default_openjdk_pkg_names(version)
        value_for_platform_family(
          amazon: ["java-1.#{version}.0-openjdk", "java-1.#{version}.0-openjdk-devel"],
          %w(rhel fedora) => version.to_i < 11 ? ["java-1.#{version}.0-openjdk", "java-1.#{version}.0-openjdk-devel"] : ["java-#{version}-openjdk", "java-#{version}-openjdk-devel"],
          suse: version.to_i == 8 ? ["java-1_#{version}_0-openjdk", "java-1_#{version}_0-openjdk-devel"] : ["java-#{version}-openjdk", "java-#{version}-openjdk-devel"],
          freebsd: "openjdk#{version}",
          arch: "openjdk#{version}",
          debian: ["openjdk-#{version}-jdk", "openjdk-#{version}-jre-headless"],
          default: ["openjdk-#{version}-jdk"]
        )
      end

      def default_openjdk_pkg_java_home(version)
        value_for_platform_family(
          %w(rhel fedora) => version.to_i < 11 ? "/usr/lib/jvm/java-1.#{version}.0" : "/usr/lib/jvm/java-#{version}",
          amazon: version.to_i < 11 ? "/usr/lib/jvm/java-1.#{version}.0" : "/usr/lib/jvm/jre-#{version}",
          suse: "/usr/lib#{node['kernel']['machine'] == 'x86_64' ? '64' : nil}/jvm/java-#{version.to_i == 8 ? "1.#{version}.0" : version}",
          freebsd: "/usr/local/openjdk#{version}",
          arch: "/usr/lib/jvm/java-#{version}-openjdk",
          debian: "/usr/lib/jvm/java-#{version}-openjdk-#{node['kernel']['machine'] == 'x86_64' ? 'amd64' : 'i386'}",
          default: '/usr/lib/jvm/default-java'
        )
      end
    end
  end
end
