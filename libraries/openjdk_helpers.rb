module Java
  module Cookbook
    module OpenJdkHelpers
      def lts
        %w(11 17)
      end

      # This method relies on the GitHub release artefact URL
      # e.g. https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.3%2B7/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.3_7.tar.gz
      def sub_dir(url)
        URI.parse(url)
        url.split('/')[7].split('_')[0].gsub('%2', '-').downcase
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

      def default_openjdk_url(version, variant = nil)
        # Always default to OpenJDK
        # If the user passes variant we'll also select that variant's URL
        case version
        when '8'
          case variant
          when 'semeru'
            'https://github.com/ibmruntimes/semeru8-binaries/releases/download/jdk8u322-b06_openj9-0.30.0/ibm-semeru-open-jdk_x64_linux_8u322b06_openj9-0.30.0.tar.gz'
          when 'temurin'
            'https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u322-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u322b06.tar.gz'
          else
            Chef::Log.fatal('Version specified does not have a URL value set')
            raise 'Version supplied does not have a download URL set'
          end
        when '9'
          'https://download.java.net/java/GA/jdk9/9/binaries/openjdk-9_linux-x64_bin.tar.gz'
        when '10'
          'https://download.java.net/java/GA/jdk10/10/binaries/openjdk-10_linux-x64_bin.tar.gz'
        when '11'
          case variant
          when 'semeru'
            'https://github.com/ibmruntimes/semeru11-binaries/releases/download/jdk-11.0.14.1%2B1_openj9-0.30.1/ibm-semeru-open-jdk_x64_linux_11.0.14.1_1_openj9-0.30.1.tar.gz'
          when 'temurin'
            'https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.15%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.15_10.tar.gz'
          else
            'https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz'
          end
        when '12'
          'https://download.java.net/java/GA/jdk12/33/GPL/openjdk-12_linux-x64_bin.tar.gz'
        when '13'
          'https://download.java.net/java/GA/jdk13/5b8a42f3905b406298b72d750b6919f6/33/GPL/openjdk-13_linux-x64_bin.tar.gz'
        when '14'
          'https://download.java.net/java/GA/jdk14/076bab302c7b4508975440c56f6cc26a/36/GPL/openjdk-14_linux-x64_bin.tar.gz'
        when '15'
          'https://download.java.net/java/GA/jdk15/779bf45e88a44cbd9ea6621d33e33db1/36/GPL/openjdk-15_linux-x64_bin.tar.gz'
        when '16'
          case variant
          when 'semeru'
            'https://github.com/ibmruntimes/semeru16-binaries/releases/download/jdk-16.0.2%2B7_openj9-0.27.1/ibm-semeru-open-jdk_ppc64le_linux_16.0.2_7_openj9-0.27.1.tar.gz'
          when 'temurin'
            'https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%2B7/OpenJDK16U-jdk_x64_linux_hotspot_16.0.2_7.tar.gz'
          else
            'https://download.java.net/java/GA/jdk16/7863447f0ab643c585b9bdebf67c69db/36/GPL/openjdk-16_linux-x64_bin.tar.gz'
          end
        when '17'
          case variant
          when 'semeru'
            'https://github.com/ibmruntimes/semeru17-binaries/releases/download/jdk-17.0.2%2B8_openj9-0.30.0/ibm-semeru-open-jdk_x64_linux_17.0.2_8_openj9-0.30.0.tar.gz'
          when 'temurin'
            'https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.1%2B10/OpenJDK18U-jdk_x64_linux_hotspot_18.0.1_10.tar.gz'
          else
            'https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz'
          end
        when '18'
          case variant
          when 'semeru'
            'https://github.com/AdoptOpenJDK/semeru18-binaries/releases/download/jdk-18.0.1%2B10_openj9-0.32.0/ibm-semeru-open-jdk_x64_linux_18.0.1_10_openj9-0.32.0.tar.gz'
          when 'temurin'
            'https://github.com/adoptium/temurin18-binaries/releases/download/jdk-18.0.1%2B10/OpenJDK18U-jdk_x64_linux_hotspot_18.0.1_10.tar.gz'
          else
            'https://download.java.net/java/GA/jdk18.0.1/3f48cabb83014f9fab465e280ccf630b/10/GPL/openjdk-18.0.1_linux-x64_bin.tar.gz'
          end
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
