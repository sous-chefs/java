#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: java
# Attributes:: default
#
# Copyright:: 2010-2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# default jdk attributes
default['java']['jdk_version'] = '8'
default['java']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i586'
default['java']['openjdk_packages'] = []
default['java']['openjdk_version'] = nil
default['java']['accept_license_agreement'] = false
default['java']['set_default'] = true
default['java']['alternatives_priority'] = 1062
default['java']['set_etc_environment'] = false
default['java']['use_alt_suffix'] = true
default['java']['reset_alternatives'] = true

# the following retry parameters apply when downloading oracle java
default['java']['ark_retries'] = 0
default['java']['ark_retry_delay'] = 2
default['java']['ark_timeout'] = 600
default['java']['ark_download_timeout'] = 600

case node['platform_family']
when 'windows'
  default['java']['install_flavor'] = 'windows'
  default['java']['windows']['url'] = nil
  default['java']['windows']['checksum'] = nil
  default['java']['windows']['package_name'] = 'Java(TM) SE Development Kit 7 (64-bit)'
  default['java']['windows']['public_jre_home'] = nil
  default['java']['windows']['owner'] = 'administrator'
  default['java']['windows']['remove_obsolete'] = false
  default['java']['windows']['returns'] = 0
when 'mac_os_x'
  default['java']['install_flavor'] = 'homebrew'
else
  default['java']['install_flavor'] = 'openjdk'
end

# type of Java installation, can be jdk or jre
default['java']['install_type'] = 'jdk'

# S390(X) - IBM zSeries Architecture - only IBM jre / jdk can be used. Download from https://developer.ibm.com/javasdk/downloads/
if node['kernel']['machine'].start_with?('s390')
  default['java']['install_flavor'] = 'ibm'
end

default['java']['ibm']['url'] = nil
default['java']['ibm']['checksum'] = nil
default['java']['ibm']['accept_ibm_download_terms'] = false

default['java']['ibm']['6']['bin_cmds'] = %w(appletviewer apt ControlPanel extcheck HtmlConverter idlj jar jarsigner
                                             java javac javadoc javah javap javaws jconsole jcontrol jdb jdmpview
                                             jrunscript keytool native2ascii policytool rmic rmid rmiregistry
                                             schemagen serialver tnameserv wsgen wsimport xjc)

default['java']['ibm']['7']['bin_cmds'] = node['java']['ibm']['6']['bin_cmds'] + %w(pack200 unpack200)
default['java']['ibm']['8']['bin_cmds'] = node['java']['ibm']['7']['bin_cmds']

# type of java RPM : jdk or jre
default['java']['oracle_rpm']['type'] = 'jdk'

# optional, can be overriden to pin to a version different
# from the up-to-date.
default['java']['oracle_rpm']['package_version'] = nil

# optional, some distros re-package the official Oracle's RPM
# with a different name
default['java']['oracle_rpm']['package_name'] = nil

# if you change this to true, you can download directly from Oracle
default['java']['oracle']['accept_oracle_download_terms'] = false

# direct download paths for oracle, you have been warned!

# jdk8 attributes

default['java']['jdk']['8']['bin_cmds'] = %w(appletviewer apt ControlPanel extcheck idlj jar jarsigner java javac
                                             javadoc javafxpackager javah javap javaws jcmd jconsole jcontrol jdb
                                             jdeps jhat jinfo jjs jmap jmc jps jrunscript jsadebugd jstack
                                             jstat jstatd jvisualvm keytool native2ascii orbd pack200 policytool
                                             rmic rmid rmiregistry schemagen serialver servertool tnameserv
                                             unpack200 wsgen wsimport xjc)

# Official checksums for the latest release can be found at https://www.oracle.com/webfolder/s/digest/8u172checksum.html

# x86_64
default['java']['jdk']['8']['x86_64']['url'] = 'https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-linux-x64.tar.gz'
default['java']['jdk']['8']['x86_64']['checksum'] = '9a5c32411a6a06e22b69c495b7975034409fa1652d03aeb8eb5b6f59fd4594e0'

# i586
default['java']['jdk']['8']['i586']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-i586.tar.gz'
default['java']['jdk']['8']['i586']['checksum'] = '640333e749f24428b78c2b10422f7174f8fbd0b8acde27526c195024fad8b6b6'

# x86_64
default['java']['jdk']['10']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/10.0.1+10/fb4372174a714e6b8c52526dc134031e/jdk-10.0.1_linux-x64_bin.tar.gz'
default['java']['jdk']['10']['x86_64']['checksum'] = 'ae8ed645e6af38432a56a847597ac61d4283b7536688dbab44ab536199d1e5a4'

# i586
default['java']['jdk']['10']['i586']['url'] = 'NOT YET AVAILABLE'
default['java']['jdk']['10']['i586']['checksum'] = 'NOT YET AVAILABLE'

default['java']['jdk']['10']['bin_cmds'] = %w(appletviewer jar javac javapackager jconsole jdeprscan jimage jlink jmod
                                              jshell jstatd orbd rmid serialver unpack200 xjc idlj jarsigner javadoc javaws
                                              jcontrol jdeps jinfo jmap jps jstack jweblauncher pack200 rmiregistry servertool wsgen
                                              jaotc java javap jcmd jdb jhsdb jjs jmc jrunscript jstat keytool rmic schemagen tnameserv
                                              wsimport)

# x86_64
default['java']['jdk']['11']['x86_64']['url'] = 'http://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz'
default['java']['jdk']['11']['x86_64']['checksum'] = 'e7fd856bacad04b6dbf3606094b6a81fa9930d6dbb044bbd787be7ea93abc885'

default['java']['jdk']['11']['bin_cmds'] = %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan
                                              jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack
                                              jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200
                                              )

default['java']['oracle']['jce']['enabled'] = false
default['java']['oracle']['jce']['10']['url'] = 'https://edelivery.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip'
default['java']['oracle']['jce']['10']['checksum'] = 'f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59'
default['java']['oracle']['jce']['8']['url'] = 'https://edelivery.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip'
default['java']['oracle']['jce']['8']['checksum'] = 'f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59'
default['java']['oracle']['jce']['7']['url'] = 'http://ORACLE_HAS_REMOVED_THESE_FILES.SELF_HOST_THEM_INSTEAD'
default['java']['oracle']['jce']['7']['checksum'] = 'CALCULATE_THIS_FROM_YOUR_FILE'
default['java']['oracle']['jce']['6']['url'] = 'http://ORACLE_HAS_REMOVED_THESE_FILES.SELF_HOST_THEM_INSTEAD'
default['java']['oracle']['jce']['6']['checksum'] = 'CALCULATE_THIS_FROM_YOUR_FILE'
default['java']['oracle']['jce']['home'] = '/opt/java_jce'

# AdoptOpenJDK
default['java']['adoptopenjdk']['variant'] = 'openj9'
# AdoptOpenJDK 8
default['java']['adoptopenjdk']['8']['x86_64']['openj9']['url'] = 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03_openj9-0.14.0/OpenJDK8U-jdk_x64_linux_openj9_jdk8u212-b03_openj9-0.14.0.tar.gz'
default['java']['adoptopenjdk']['8']['x86_64']['openj9']['checksum'] = '4aa8fdb3916816788c516423236bef68a05a694cbd44fa14c4f8f5b76891aa4c'
default['java']['adoptopenjdk']['8']['x86_64']['openj9-jre']['url'] = 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03_openj9-0.14.0/OpenJDK8U-jre_x64_linux_openj9_jdk8u212-b03_openj9-0.14.0.tar.gz'
default['java']['adoptopenjdk']['8']['x86_64']['openj9-jre']['checksum'] = '61abbd6b4ab093adb5a0ed6ec89a54123396d8512a44168f7e01d3e7b1fdd07b'
default['java']['adoptopenjdk']['8']['x86_64']['openj9-large-heap']['url'] = 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u212-b03_openj9-0.14.0/OpenJDK8U-jdk_x64_linux_openj9_linuxXL_jdk8u212-b03_openj9-0.14.0.tar.gz'
default['java']['adoptopenjdk']['8']['x86_64']['openj9-large-heap']['checksum'] = 'cf1a9701e192656923b27c1adeb8903b92c69ee735f38316cef5a9e90899af92'
default['java']['adoptopenjdk']['8']['x86_64']['hotspot']['url'] = 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u202b08.tar.gz'
default['java']['adoptopenjdk']['8']['x86_64']['hotspot']['checksum'] = 'f5a1c9836beb3ca933ec3b1d39568ecbb68bd7e7ca6a9989a21ff16a74d910ab'
default['java']['adoptopenjdk']['8']['x86_64']['hotspot-jre']['url'] = 'https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jre_x64_linux_hotspot_8u202b08.tar.gz'
default['java']['adoptopenjdk']['8']['x86_64']['hotspot-jre']['checksum'] = 'b3f9934c6fc83fb2e76a4ded31367e5312013e27d36eac82a6fe1423aae394ce'
default['java']['adoptopenjdk']['8']['bin_cmds']['default'] = %w(appletviewer extcheck idlj jar jarsigner java javac javadoc javah javap jconsole jdb jdeps jdmpview jextract jjs jrunscript jsadebugd keytool native2ascii orbd pack200 policytool rmic rmid rmiregistry schemagen serialver servertool tnameserv traceformat unpack200 wsgen wsimport xjc)
default['java']['adoptopenjdk']['8']['bin_cmds']['openj9-jre'] = %w(java jjs keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200)
default['java']['adoptopenjdk']['8']['bin_cmds']['hotspot-jre'] = %w(java jjs keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200)
# AdoptOpenJDK 10
default['java']['adoptopenjdk']['10']['x86_64']['hotspot']['url'] = 'https://github.com/AdoptOpenJDK/openjdk10-releases/releases/download/jdk-10.0.2%2B13/OpenJDK10_x64_Linux_jdk-10.0.2.13.tar.gz'
default['java']['adoptopenjdk']['10']['x86_64']['hotspot']['checksum'] = 'f8caa2e8c28370e3b8e455686e1ddeb74656f068848f8c355d9d8d1c225528f4'
default['java']['adoptopenjdk']['10']['x86_64']['openj9']['url'] = 'https://github.com/AdoptOpenJDK/openjdk10-openj9-releases/releases/download/jdk-10.0.2%2B13_openj9-0.9.0/OpenJDK10-OPENJ9_x64_Linux_jdk-10.0.2.13_openj9-0.9.0.tar.gz'
default['java']['adoptopenjdk']['10']['x86_64']['openj9']['checksum'] = '1ef0dab3853b2f3666091854ef8149fcb85970254558d5d62cfa9446831779d1'
default['java']['adoptopenjdk']['10']['bin_cmds']['default'] = %w(appletviewer idlj jar jarsigner java javac javadoc javap jconsole jdb jdeprscan jdeps jdmpview jextract jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat keytool orbd pack200 rmic rmid rmiregistry schemagen serialver servertool tnameserv traceformat unpack200 wsgen wsimport xjc)
default['java']['adoptopenjdk']['10']['bin_cmds']['hotspot'] = %w(appletviewer idlj jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool orbd pack200 rmic rmid rmiregistry schemagen serialver servertool tnameserv unpack200 wsgen wsimport xjc)
# AdoptOpenJDK 11
default['java']['adoptopenjdk']['11']['x86_64']['hotspot']['url'] = 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11%2B28/OpenJDK11-jdk_x64_linux_hotspot_11_28.tar.gz'
default['java']['adoptopenjdk']['11']['x86_64']['hotspot']['checksum'] = 'e1e18fc9ce2917473da3e0acb5a771bc651f600c0195a3cb40ef6f22f21660af'
default['java']['adoptopenjdk']['11']['x86_64']['openj9']['url'] = 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.1%2B13/OpenJDK11-jdk_x64_linux_openj9_11.0.1_13.tar.gz'
default['java']['adoptopenjdk']['11']['x86_64']['openj9']['checksum'] = '765947ab9457a29d2aa9d11460a4849611343c1e0ea3b33b9c08409cd4672251'
default['java']['adoptopenjdk']['11']['x86_64']['openj9-large-heap']['url'] = 'https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.1%2B13/OpenJDK11-jdk_x64_linux_openj9_linuxXL_11.0.1_13.tar.gz'
default['java']['adoptopenjdk']['11']['x86_64']['openj9-large-heap']['checksum'] = '0b6050cc670eefd9465370ab19ae70401476430fca329e65f0dd636ca9cce9bd'
default['java']['adoptopenjdk']['11']['bin_cmds']['default'] = %w(jar jarsigner java javac javadoc javap jconsole jdb jdeprscan jdeps jdmpview jextract jimage jjs jlink jrunscript jshell keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200)
default['java']['adoptopenjdk']['11']['bin_cmds']['hotspot'] = %w(jaotc jar jarsigner java javac javadoc javap jcmd jconsole jdb jdeprscan jdeps jhsdb jimage jinfo jjs jlink jmap jmod jps jrunscript jshell jstack jstat jstatd keytool pack200 rmic rmid rmiregistry serialver unpack200)
# AdoptOpenJDK 12
default['java']['adoptopenjdk']['12']['x86_64']['hotspot']['url'] = 'https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12%2B33/OpenJDK12U-jdk_x64_linux_hotspot_12_33.tar.gz'
default['java']['adoptopenjdk']['12']['x86_64']['hotspot']['checksum'] = '4739064dc439a05487744cce0ba951cb544ed5e796f6c699646e16c09da5dd6a'
default['java']['adoptopenjdk']['12']['x86_64']['openj9']['url'] = 'https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12%2B33_openj9-0.13.0/OpenJDK12U-jdk_x64_linux_openj9_12_33_openj9-0.13.0.tar.gz'
default['java']['adoptopenjdk']['12']['x86_64']['openj9']['checksum'] = 'd61a7a211b314aab9d79bc003b8ce86d5651e705912a24e369a44ae5206afed5'
default['java']['adoptopenjdk']['12']['x86_64']['openj9-large-heap']['url'] = 'https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12%2B33_openj9-0.13.0/OpenJDK12U-jdk_x64_linux_openj9_linuxXL_12_33_openj9-0.13.0.tar.gz'
default['java']['adoptopenjdk']['12']['x86_64']['openj9-large-heap']['checksum'] = '2aa705567b8fca07a9ac9b6ad870934e5657ef649c303c37b8383f7df4ca6e1f'
default['java']['adoptopenjdk']['12']['bin_cmds']['default'] = %w(jar jarsigner java javac javadoc javap jconsole jdb jdeprscan jdeps jdmpview jextract jfr jimage jjs jlink jmod jps jrunscript jshell keytool pack200 rmic rmid rmiregistry serialver traceformat unpack200)
