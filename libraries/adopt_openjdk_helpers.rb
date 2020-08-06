module Java
  module Cookbook
    module AdoptOpenJdkHelpers
      def sub_dir(url)
        uri = URI.parse(url)
        # get file basename without extension
        basename = uri.path.split('/')[-1].gsub('.tar.gz', '')

        if basename.include?('linuxXL') # compensate for longer name
          # Get version number from start of filename
          if (basename.scan /\d+/)[0] == '8'
            ver = basename.split('_')[5]
            "jdk#{ver[0..4]}-#{ver[-3..-1]}"
          else
            ver = basename.split('_')
            "jdk-#{ver[5]}+#{ver[6]}"
          end
        elsif (basename.scan /\d+/)[0] == '8'
          ver = basename.split('_')[4]
          "jdk#{ver[0..4]}-#{ver[-3..-1]}"
        else
          ver = basename.split('_')
          "jdk-#{ver[4]}+#{ver[5]}"
        end
      end

      def default_adopt_openjdk_url(version)
        case version
        when '8'
          { 'hotspot' => 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u242b08.tar.gz',
            'openj9' => 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_8u242b08_openj9-0.18.1.tar.gz',
            'openj9-large-heap' => 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u242-b08_openj9-0.18.1/OpenJDK8U-jdk_x64_linux_openj9_linuxXL_8u242b08_openj9-0.18.1.tar.gz',
          }
        when '11'
          { 'hotspot' => 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.6_10.tar.gz',
            'openj9' => 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_11.0.6_10_openj9-0.18.1.tar.gz',
            'openj9-large-heap' => 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10_openj9-0.18.1/OpenJDK11U-jdk_x64_linux_openj9_linuxXL_11.0.6_10_openj9-0.18.1.tar.gz',
           }
        when '13'
          { 'hotspot' => 'https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.2%2B8/OpenJDK13U-jdk_x64_linux_hotspot_13.0.2_8.tar.gz',
            'openj9' => 'https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.2%2B8_openj9-0.18.0/OpenJDK13U-jdk_x64_linux_openj9_13.0.2_8_openj9-0.18.0.tar.gz',
            'openj9-large-heap' => 'https://github.com/AdoptOpenJDK/openjdk13-binaries/releases/download/jdk-13.0.2%2B8_openj9-0.18.0/OpenJDK13U-jdk_x64_linux_openj9_linuxXL_13.0.2_8_openj9-0.18.0.tar.gz',
          }
        when '14'
          {
            'hotspot' => 'https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36/OpenJDK14U-jdk_x64_linux_hotspot_14_36.tar.gz',
            'openj9' => 'https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36.1_openj9-0.19.0/OpenJDK14U-jdk_x64_linux_openj9_14_36_openj9-0.19.0.tar.gz',
            'openj9-large-heap' => 'https://github.com/AdoptOpenJDK/openjdk14-binaries/releases/download/jdk-14%2B36.1_openj9-0.19.0/OpenJDK14U-jdk_x64_linux_openj9_linuxXL_14_36_openj9-0.19.0.tar.gz',
          }
        else
          Chef::Log.fatal('Version specified does not have a URL value set')
        end
      end

      def default_adopt_openjdk_checksum(version)
        case version
        when '8'
          { 'hotspot' => 'f39b523c724d0e0047d238eb2bb17a9565a60574cf651206c867ee5fc000ab43',
            'openj9' => 'ca785af638b24f9d4df896f5a9f557cc9f1e5fa5e2b1174d6b906e3fd5474c2e',
            'openj9-large-heap' => '6ee788d57f15cc8c326bb3468390d5e353cc1aac1925efa3f2992a93e2520d97',
          }
        when '11'
          { 'hotspot' => '330d19a2eaa07ed02757d7a785a77bab49f5ee710ea03b4ee2fa220ddd0feffc',
            'openj9' => '1530172ee98edd129954fcdca1bf725f7b30c8bfc3cdc381c88de96b7d19e690',
            'openj9-large-heap' => '6524d85d2ce334c955a4347015567326067ef15fe5f6a805714b25cace256f40',
          }
        when '13'
          { 'hotspot' => '9ccc063569f19899fd08e41466f8c4cd4e05058abdb5178fa374cb365dcf5998',
            'openj9' => 'aeecf6d30d0c847db81d07793cf97e5dc44890c29366d7d9f8f9f397f6c52590',
            'openj9-large-heap' => '16751b3951b808c4cb0b77d4df1a16f9bfff5b2dbc59919773e6386114e6d8d5',
          }
        when '14'
          { 'hotspot' => '6c06853332585ab58834d9e8a02774b388e6e062ef6c4084b4f058c67f2e81b5',
            'openj9' => '106b72d565be98834ead5fea9555bd646d488a86fc4ae4dd294a38e97bf77509',
            'openj9-large-heap' => '4ee13d0689ab7a38d6abb7dee974c3b189e36f1911a0cb61c882a38e61cc8b98',
          }
        else
          Chef::Log.fatal('Version specified does not have a checksum value set')
        end
      end

      def default_adopt_openjdk_bin_cmds(version)
        case version
        when '8'
          { 'hotspot' => ['appletviewer', 'clhsdb', 'extcheck', 'hsdb', 'idlj', 'jar', 'jarsigner', 'java', 'java-rmi.cgi', 'javac', 'javadoc', 'javah', 'javap', 'jcmd', 'jconsole', 'jdb', 'jdeps', 'jhat', 'jinfo', 'jjs', 'jmap', 'jps', 'jrunscript', 'jsadebugd', 'jstack', 'jstat', 'jstatd', 'keytool', 'native2ascii', 'orbd', 'pack200', 'policytool', 'rmic', 'rmid', 'rmiregistry', 'schemagen', 'serialver', 'servertool', 'tnameserv', 'unpack200', 'wsgen', 'wsimport', 'xjc'],
            'openj9' => ['appletviewer', 'extcheck', 'idlj', 'jar', 'jarsigner', 'java', 'java-rmi.cgi', 'javac', 'javadoc', 'javah', 'javap', 'jcmd', 'jconsole', 'jdb', 'jdeps', 'jdmpview', 'jitserver', 'jjs', 'jmap', 'jps', 'jrunscript', 'jsadebugd', 'jstack', 'jstat', 'keytool', 'native2ascii', 'orbd', 'pack200', 'policytool', 'rmic', 'rmid', 'rmiregistry', 'schemagen', 'serialver', 'servertool', 'tnameserv', 'traceformat', 'unpack200', 'wsgen', 'wsimport', 'xjc'],
            'openj9-large-heap' => ['appletviewer', 'extcheck', 'idlj', 'jar', 'jarsigner', 'java', 'java-rmi.cgi', 'javac', 'javadoc', 'javah', 'javap', 'jcmd', 'jconsole', 'jdb', 'jdeps', 'jdmpview', 'jitserver', 'jjs', 'jmap', 'jps', 'jrunscript', 'jsadebugd', 'jstack', 'jstat', 'keytool', 'native2ascii', 'orbd', 'pack200', 'policytool', 'rmic', 'rmid', 'rmiregistry', 'schemagen', 'serialver', 'servertool', 'tnameserv', 'traceformat', 'unpack200', 'wsgen', 'wsimport', 'xjc'] }
        when '11'
          { 'hotspot' => %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200),
            'openj9' => %w(jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jdmpview jextract jimage jitserver jjs jlink jmap jmod jps jrunscript jshell jstack jstat keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200),
            'openj9-large-heap' => %w(jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jdmpview jextract jimage jitserver jjs jlink jmap jmod jps jrunscript jshell jstack jstat keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200) }
        when '13', '14'
          { 'hotspot' => %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jfr jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200),
            'openj9' => %w(jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jdmpview jextract jimage jjs jlink jmap jmod jps jrunscript jshell jstack jstat keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200),
            'openj9-large-heap' => %w(jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jdmpview jextract jimage jjs jlink jmap jmod jps jrunscript jshell jstack jstat keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200) }
        else
          Chef::Log.fatal('Version specified does not have a default set of bin_cmds')
        end
      end
    end
  end
end
