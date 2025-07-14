module Java
  module Cookbook
    module BinCmdHelpers
      def default_bin_cmds(version)
        case version
        when '8'
          %w(appletviewer extcheck idlj jar jarsigner java javac javadoc javah javap jcmd jconsole jdb jdeps jhat jinfo jjs jmap jps jrunscript jsadebugd jstack jstat jstatd keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '9'
          %w(appletviewer idlj jaotc jar jarsigner java javac javadoc javah javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '10'
          %w(appletviewer idlj jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool orbd pack200 rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
        when '11'
          %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
        when '12', '13', '14', '15', '16'
          %w(jaotc jarsigner javac javap jconsole jdeprscan jfr jimage jjs jmap jps jshell jstat keytool rmic rmiregistry unpack200 jar java javadoc jcmd jdb jdeps jhsdb jinfo jlink jmod jrunscript jstack jstatd pack200 rmid serialver)
        when '17'
          %w(jarsigner javac javap jconsole jdeprscan jfr jimage jjs jmap jps jshell jstat keytool rmic rmiregistry unpack200 jar java javadoc jcmd jdb jdeps jhsdb jinfo jlink jmod jrunscript jstack jstatd pack200 rmid serialver)
        when '18', '19', '20', '21', '22', 'latest'
          %w(jarsigner javac javap jconsole jdeprscan jfr jimage jjs jmap jps jshell jstat keytool rmic rmiregistry unpack200 jar java javadoc jcmd jdb jdeps jhsdb jinfo jlink jmod jrunscript jstack jstatd pack200 rmid serialver jwebserver)
        else
          Chef::Log.fatal('Version specified does not have a default set of bin_cmds')
        end
      end
    end
  end
end
