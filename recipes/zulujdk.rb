jdk_version=node[:java][:jdk_version]
if platform?('windows')

   windows_package 'zulu-Jdk' do
        node.override[:java][:java_home]="C:\\Program Files\\Zulu\\zulu-#{jdk_version}\\bin"
        case jdk_version
        when '11'
          url=node['zulu']['java']['windows']['11']['x86_64']['url']
        when '10'
          url=node['zulu']['java']['windows']['10']['x86_64']['url']
        when '9'
          url=node['zulu']['java']['windows']['9']['x86_64']['url']
        when '8'
          url=node['zulu']['java']['windows']['8']['x86_64']['url']
        else
           raise 'Unsupported JDK version'
        end
        source url
        installer_type :msi
        action :install
   end
   #Install ZCCK for windows
   windows_package 'Windows CCK' do
        source node['zulu']['cck']['windows'][jdk_version]['x86_64']['url']
        installer_type :msi
        action :install
        only_if {node['zulu']['cck']['windows'][jdk_version]['x86_64']['url'] != nil }
   end

elsif platform_family?('rhel','oracle')
   yum_repository 'zulu-$releasever - Azul Systems Inc., Zulu packages for $basearch' do
      name 'zulu'
      baseurl 'http://repos.azulsystems.com/rhel/$releasever/$basearch'
      gpgkey 'http://repos.azulsystems.com/RPM-GPG-KEY-azulsystems'
      action :create
   end
   package "zulu-#{jdk_version}"
   #Install ZCCK for linux
   rpm_package 'Linux ZCCK' do
        source node['zulu']['cck']['linux'][jdk_version]['x86_64']['url']
        action :install
        only_if {node['zulu']['cck']['linux'][jdk_version]['x86_64']['url'] != nil }
   end   
else
   raise "Unsupported platform"
end
