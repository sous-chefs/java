# java cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/java.svg)](https://supermarket.chef.io/cookbooks/java)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/java/master.svg)](https://circleci.com/gh/sous-chefs/java)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This cookbook installs a Java JDK/JRE. It defaults to installing OpenJDK, but it can also install Oracle, IBM JDKs or AdoptOpenJDK.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Production Deployment with Oracle Java

Oracle has been known to change the behavior of its download site frequently. It is recommended you store the archives on an artifact server or s3 bucket. You can then override the attributes in a cookbook, role, or environment:

```ruby
default['java']['jdk_version'] = '8'
default['java']['install_flavor'] = 'oracle'
default['java']['jdk']['7']['x86_64']['url'] = 'http://artifactory.example.com/artifacts/jdk-7u65-linux-x64.tar.gz'
default['java']['jdk']['7']['x86_64']['checksum'] = 'The SHA-256 checksum of the JDK archive'
default['java']['oracle']['accept_oracle_download_terms'] = true
```

## Usage

Include the `java` recipe wherever you would like Java installed, such as a run list (`recipe[java]`) or a cookbook (`include_recipe 'java'`). By default, OpenJDK 6 is installed. The `install_flavor` attribute is used to determine which JDK to install (AdoptOpenJDK, OpenJDK, Oracle, IBM, or Windows), and `jdk_version` specifies which version to install (currently 6 and 7 are supported for all JDK types, 8 and 10 for Oracle and AdoptOpenJDK ).

### Examples

To install Oracle Java 7 (note that when installing Oracle JDK, `accept_oracle_download_terms` attribute must be set -- see below role for an example):

```ruby
name "java"
description "Install Oracle Java"
default_attributes(
  "java" => {
    "install_flavor" => "oracle",
    "jdk_version" => "7",
    "oracle" => {
      "accept_oracle_download_terms" => true
    }
  }
)
run_list(
  "recipe[java]"
)
```

Example role to install IBM flavored Java:

```ruby
name "java"
description "Install IBM Java on Ubuntu"
default_attributes(
  "java" => {
    "install_flavor" => "ibm",
    "ibm" => {
      "accept_ibm_download_terms" => true,
      "url" => "http://fileserver.example.com/ibm-java-x86_64-sdk-7.0-4.1.bin",
      "checksum" => "The SHA256 checksum of the bin"
    }
  }
)
run_list(
  "recipe[java]"
)
```

## Requirements

Chef 13.4+

### Platforms

- Debian, Ubuntu
- CentOS, RedHat, Fedora, Scientific, Amazon
- ArchLinux
- FreeBSD
- Windows
- macOS

### Cookbooks

- homebrew

## Attributes

See `attributes/default.rb` for default values.

- `node['java']['download_path']` - Location to download and extract the tarball
- `node['java']['install_flavor']` - Flavor of JVM you would like installed (`oracle`, `oracle_rpm`, `openjdk`, `adoptopenjdk`, `ibm`, `windows`), default `openjdk` on Linux/Unix platforms, `windows` on Windows platforms.
- `node['java']['install_type']` - Type of Java installation, defauls to jdk, needed for JCE to find the install path of jar's for JDK/JRE installation.
- `node['java']['jdk_version']` - JDK version to install, defaults to `'6'`.
- `node['java']['java_home']` - Default location of the "`$JAVA_HOME`". To configure this attribute for `ibm`, `ibm_tar`, and `oracle_rpm` install flavors, you must use an attribute precedence of `force_default` or higher in your attribute file.
- `node['java']['set_etc_environment']` - Optionally sets JAVA_HOME in `/etc/environment` for Default `false`.
- `node['java']['openjdk_packages']` - Array of OpenJDK package names to install in the `java::openjdk` recipe. This is set based on the platform.
- `node['java']['jdk']` - Version and architecture specific attributes for setting the URL on Oracle's site for the JDK, and the checksum of the .tar.gz.
- `node['java']['oracle']['accept_oracle_download_terms']` - Indicates that you accept Oracle's EULA
- `node['java']['windows']['url']` - The internal location of your java install for windows
- `node['java']['windows']['package_name']` - The package name used by windows_package to check in the registry to determine if the install has already been run
- `node['java']['windows']['checksum']` - The checksum for the package to download on Windows machines (default is nil, which does not perform checksum validation)
- `node['java']['windows']['remove_obsolete']` - Indicates whether to remove previous versions of the JRE (default is `false`)
- `node['java']['windows']['aws_access_key_id']` - AWS Acess Key ID to use with AWS API calls
- `node['java']['windows']['aws_secret_access_key']` - AWS Secret Access Key to use with AWS API calls
- `node['java']['windows']['aws_session_token']` - AWS Session Token to use with AWS API calls
- `node['java']['windows']['returns']` - The allowed return codes for the package to
  be installed on Windows machines (default is 0, you can define an array of valid values.)
- `node['java']['ibm']['url']` - The URL which to download the IBM JDK/SDK. See the `ibm` recipe section below.
- `node['java']['ibm']['accept_ibm_download_terms']` - Indicates that you accept IBM's EULA (for `java::ibm`)
- `node['java']['oracle_rpm']['type']` - Type of java RPM (`jre` or `jdk`), default `jdk`
- `node['java']['oracle_rpm']['package_version']` - optional, can be set to pin a version different from the up-to-date one available in the YUM repo, it might be needed to also override the node['java']['java_home'] attribute to a value consistent with the defined version
- `node['java']['oracle_rpm']['package_name']` - optional, can be set to define a package name different from the RPM published by Oracle.
- `node['java']['accept_license_agreement']` - Indicates that you accept the EULA for openjdk package installation.
- `node['java']['set_default']` - Indicates whether or not you want the JDK installed to be default on the system. Defaults to true.
- `node['java']['oracle']['jce']['enabled']` - Indicates if the JCE Unlimited Strength Jurisdiction Policy Files should be installed for oracle JDKs
- `node['java']['oracle']['jce']['home']` - Where the JCE policy files should be installed to
- `node['java']['oracle']['jce'][java_version]['checksum']` - Checksum of the JCE policy zip. Can be sha256 or md5
- `node['java']['oracle']['jce'][java_version]['url']` - URL which to download the JCE policy zip
- `node['java']['adoptopenjdk']['variant']` - Install the Eclipse Openj9 (default), Eclipse OpenJ9 Large Heap or Hotspot version of AdoptOpenJDK

## Recipes

### default

Include the default recipe in a run list or recipe to get `java`. By default the `openjdk` flavor of Java is installed, but this can be changed by using the `install_flavor` attribute. By default on Windows platform systems, the `install_flavor` is `windows` and on Mac OS X platform systems, the `install_flavor` is `homebrew`.

OpenJDK is the default because of licensing changes made upstream by Oracle. See notes on the `oracle` recipe below.

NOTE: In most cases, including just the default recipe will be sufficient. It's possible to include the install_type recipes directly, as long as the necessary attributes (such as java_home) are set.

### set_attributes_from_version

Sets default attributes based on the JDK version. This is included by `default.rb`. This logic must be in a recipe instead of attributes/default.rb. See [#95](https://github.com/agileorbit-cookbooks/java/pull/95) for details.

### default_java_symlink

Updates /usr/lib/jvm/default-java to point to JAVA_HOME.

### openjdk

This recipe installs the `openjdk` flavor of Java. It also uses the `alternatives` system on RHEL/Debian families to set the default Java.

On platforms such as SmartOS that require the acceptance of a license agreement during package installation, set `node['java']['accept_license_agreement']` to true in order to indicate that you accept the license.

### oracle

This recipe installs the `oracle` flavor of Java. This recipe does not use distribution packages as Oracle changed the licensing terms with JDK 1.6u27 and prohibited the practice for both RHEL and Debian family platforms.

You can not directly download the JDK from Oracle's website without using a special cookie. This cookbook uses that cookie to download the oracle recipe on your behalf, however the `java::oracle` recipe forces you to set either override the `node['java']['oracle']['accept_oracle_download_terms']` to true or set up a private repository accessible by HTTP.

override the `accept_oracle_download_terms` in, e.g., `roles/base.rb`

```ruby
    default_attributes(
      :java => {
         :oracle => {
           "accept_oracle_download_terms" => true
         }
       }
    )
```

For both RHEL and Debian families, this recipe pulls the binary distribution from the Oracle website, and installs it in the default `JAVA_HOME` for each distribution. For Debian, this is `/usr/lib/jvm/default-java`. For RHEL, this is `/usr/lib/jvm/java`.

After putting the binaries in place, the `java::oracle` recipe updates `/usr/bin/java` to point to the installed JDK using the `update-alternatives` script. This is all handled in the `java_oracle_install` resource.

### oracle_i386

This recipe installs the 32-bit Java virtual machine without setting it as the default. This can be useful if you have applications on the same machine that require different versions of the JVM.

This recipe operates in a similar manner to `java::oracle`.

### oracle_rpm

This recipe installs the Oracle JRE or JDK provided by a custom YUM repositories. It also uses the `alternatives` system on RHEL families to set the default Java.

While public YUM repos for Oracle Java 7 and prior are available, you need to download the RPMs manually for Java 8 and make your own internal repository. This must be done to use this recipe to install Oracle Java 8 via RPM. You will also likely need to set `node['java']['oracle_rpm']['package_name']` to `jdk1.8.0_40`, replacing `40` with the most current version in your local repo.

### adoptopenjdk

This recipe installs the `AdoptOpenJDK` flavor of Java from [https://adoptopenjdk.net/](https://adoptopenjdk.net/). It also uses the `alternatives` system on the RHEL/Debian families to set the default Java.

### Amazon Corretto

This recipe installs the `Amazon Corretto` flavor of OpenJDK from [https://aws.amazon.com/corretto/](https://aws.amazon.com/corretto/).  It also uses the `alternatives` system on RHEL/Debian families to set the default Java.

### windows

Because as of 26 March 2012 you can no longer directly download the JDK msi from Oracle's website without using a special cookie. This recipe requires you to set `node['java']['oracle']['accept_oracle_download_terms']` to true or host it internally on your own http repo or s3 bucket.

**IMPORTANT NOTE**

If you use the `windows` recipe, you'll need to make sure you've uploaded the `aws` and `windows` cookbooks. As of version 1.18.0, this cookbook references them with `suggests` instead of `depends`, as they are only used by the `windows` recipe.

### ibm

The `java::ibm` recipe is used to install the IBM version of Java. Note that IBM requires you to create an account _and_ log in to download the binary installer for your platform. You must accept the license agreement with IBM to use their version of Java. In this cookbook, you indicate this by setting `node['java']['ibm']['accept_ibm_download_terms']` to `true`. You must also host the binary on your own HTTP server to have an automated installation. The `node['java']['ibm']['url']` attribute must be set to a valid https/http URL; the URL is checked for validity in the recipe.

At this time the `java::ibm` recipe does not support multiple SDK installations.

### notify

The `java::notify` recipe contains a log resource whose `:write` action is called when a JDK version changes. This gives cookbook authors a way to subscribe to JDK changes and take actions (say restart a java service):

```ruby
service 'somejavaservice' do
  action :restart
  subscribes :restart, 'log[jdk-version-changed]', :delayed
end
```

## Resources

### java_oracle_install

This cookbook contains the `java_oracle_install` resource which handles installation of Oracle's distribution of Java..

By default, the extracted directory is extracted to `app_root/extracted_dir_name` and symlinked to `app_root/default`

#### Actions

- `:install`: extracts the tarball and makes necessary symlinks
- `:remove`: removes the tarball and run update-alternatives for all symlinked `bin_cmds`

#### Attribute Parameters

- `url`: path to tarball, .tar.gz, .bin (oracle-specific), and .zip currently supported
- `checksum`: SHA256 checksum, not used for security but avoid redownloading the archive on each chef-client run
- `app_home`: the default for installations of this type of application, for example, `/usr/lib/tomcat/default`. If your application is not set to the default, it will be placed at the same level in the directory hierarchy but the directory name will be `app_root/extracted_directory_name + "_alt"`
- `app_home_mode`: file mode for app_home, is an integer
- `bin_cmds`: array of binary commands that should be symlinked to `/usr/bin`, examples are mvn, java, javac, etc. These cmds must be in the `bin` subdirectory of the extracted folder. Will be ignored if this `java_oracle_install` is not the default
- `owner`: owner of extracted directory, set to "root" by default
- `group`: group of extracted directory, set to `:owner` by default
- `default`: whether this the default installation of this package, boolean true or false
- `reset_alternatives`: whether alternatives is reset boolean true or false
- `use_alt_suffix`: whether `_alt` suffix is used for not default javas boolean true or false
- `proxy`: optional address and port of proxy server, for example, `proxy.example.com:1234`

#### Examples

```ruby
# install jdk6 from Oracle
java_oracle_install "jdk" do
    url 'http://download.oracle.com/otn/java/jdk/6u29-b11/jdk-6u29-linux-x64.bin'
    checksum  'a8603fa62045ce2164b26f7c04859cd548ffe0e33bfc979d9fa73df42e3b3365'
    app_home '/usr/local/java/default'
    bin_cmds ["java", "javac"]
    action :install
end
```

### adoptopenjdk_install

This cookbook contains the `adoptopenjdk_install` resource which handles the installation of AdopOpenJDK's distribution of Java.

By default, the extracted directory is extracted to `app_root/extracted_dir_name` and symlinked to `app_root/default`

#### Actions

- `:install`: extracts the tarball and makes necessary symlinks
- `:remove`: removes the tarball and run update-alternatives for all symlinked `bin_cmds`

#### Attribute Parameters

- `url`: path to tarball, .tar.gz is currently supported
- `checksum`: SHA256 checksum, not used for security but avoid redownloading the archive on each chef-client run
- `app_home`: the default for installations of this type of application, for example, `/usr/lib/tomcat/default`.
- `app_home_mode`: file mode for app_home, is an integer
- `bin_cmds`: array of binary commands that should be symlinked to `/usr/bin`, examples are mvn, java, javac, etc. These cmds must be in the `bin` subdirectory of the extracted folder. Will be ignored if this `java_oracle_install` is not the default
- `owner`: owner of extracted directory, set to "root" by default
- `group`: group of extracted directory, set to `:owner` by default
- `default`: whether this the default installation of this package, boolean true or false
- `reset_alternatives`: whether alternatives is reset boolean true or false
- `variant`: One of `hotspot`, `openj9`, or `openj9-large-heap`

#### Examples

```ruby
# install Java 10 from AdoptOpenJDK
adoptopenjdk_install "jdk" do
    url 'https://github.com/AdoptOpenJDK/openjdk10-openj9-releases/releases/download/jdk-10.0.2%2B13_openj9-0.9.0/OpenJDK10-OPENJ9_x64_Linux_jdk-10.0.2.13_openj9-0.9.0.tar.gz'
    checksum  '1ef0dab3853b2f3666091854ef8149fcb85970254558d5d62cfa9446831779d1'
    app_home '/usr/local/java/default'
    bin_cmds ["java", "javac"]
    action :install
end
```

### java_alternatives

The `java_alternatives` resource uses `update-alternatives` command to set and unset command alternatives for various Java tools such as java, javac, etc.

#### Actions

- `:set`: set alternatives for Java tools
- `:unset`: unset alternatives for Java tools

#### Attribute Parameters

- `java_location`: Java installation location.
- `bin_cmds`: array of Java tool names to set or unset alternatives on.
- `default`: whether to set the Java tools as system default. Boolean, defaults to `true`.
- `priority`: priority of the alternatives. Integer, defaults to `1061`.

#### Examples

```ruby
# set alternatives for java and javac commands
java_alternatives "set java alternatives" do
    java_location '/usr/local/java'
    bin_cmds ["java", "javac"]
    action :set
end
```

### java_certificate

This cookbook contains the `java_certificate` resource which simplifies adding certificates to a java keystore. It can also populate the keystore with a certificate retrieved from a given SSL end-point. It defaults to the default keystore `<java_home>/jre/lib/security/cacerts` for Java 8 or below and `<java_home>/lib/security/cacerts` for Java 9+ with the default password if a specific keystore is not provided.

### Actions

- `:install`: installs a certificate.
- `:remove`: removes a certificate.

### Attribute Parameters

- `cert_alias`: The alias of the certificate in the keystore. This defaults to the name of the resource.

Optional parameters:

- `java_home`: the java home directory. Defaults to `node['java']['java_home']`.

- `keystore_path`: the keystore path. Defaults to `node['java']['java_home']/jre/lib/security/cacerts` for Java 8 or below and `node['java']['java_home']/lib/security/cacerts` for Java 9+.

- `keystore_passwd`: the keystore password. Defaults to 'changeit' as specified by the Java Documentation.

Only one of the following

- `cert_data`: the certificate data to install
- `cert_file`: path to a certificate file to install
- `ssl_endpoint`: an SSL end-point from which to download the certificate

### Examples

```ruby
java_certificate "Install LDAP server certificate to Java CA keystore for Jenkins" do
    cert_alias node['jenkins']['ldap']['url'][/\/\/(.*)/, 1]
    ssl_endpoint node['jenkins']['ldap']['url']
    action :install
    notifies :restart, "runit_service[jenkins]", :delayed
end
```

### java_jce

This cookbook contains the `java_jce` resource, which installs the Java Cryptography Extension (JCE) policy files for a given Java installation.  It defaults to installing the JCE files into the Java location defined by cookbook attributes, but it can be customized to install to arbitrary Java locations.  Please note that if `node['java']['oracle']['jce']['enabled']` is set to true, this custom resource will be run automatically.

### Actions

- `:install`: Installs the JCE policy files.

### Attribute Parameters

No attributes are required by this resource.

Optional parameters:

- `jdk_version`: The Java version to install into. Defaults to `node['java']['jdk_version']`.
- `jce_url`: The URL for the JCE distribution. Defaults to `node['java']['oracle']['jce'][jdk_version]['url']`.
- `jce_checksum`: The checksum of the JCE distribution. Defaults to `node['java']['oracle']['jce'][jdk_version]['checksum']`.
- `jce_cookie`: Indicates that you accept Oracle's EULA. Defaults to the value of `node['java']['oracle']['accept_oracle_download_terms']`.
- `jce_home`: The location where JCE files will be decompressed for installation.  Defaults to `node['java']['oracle']['jce']['home']`.
- `java_home`: The location of the Java installation.. Defaults to `node['java']['java_home']`.
- `principal`: For Windows installations only, this determines the owner of the JCE files. Defaults to `node['java']['windows']['owner']`.

### Examples

``` ruby
# Install the JCE for the default Java installation:
java_jce  "Install the JCE files" do
end

# Install the JCE for a Java installation in /opt/tools/jdk8:
java_jce "Install the JCE files" do
  java_home "/opt/tools/jdk8"
end

# Install the JCE for a Java 8 installation in /opt/tools/java using a custom download location:
java_jce "Install the JCE files" do
  java_home "/opt/tools/java"
  jdk_version "8"
  jce_url "https://artifacts/path/to/jce/policy.zip"
  jce_checksum "deadbeefcafe..."
end
```

## Recommendations for inclusion in community cookbooks

This cookbook is a dependency for many other cookbooks in the Java/Chef sphere. Here are some guidelines for including it into other cookbooks:

### Allow people to not use this cookbook

Many users manage Java on their own or have systems that already have java installed. Give these users an option to skip this cookbook, for example:

```ruby
include_recipe 'java' if node['maven']['install_java']
```

This would allow a users of the maven cookbook to choose if they want the maven cookbook to install java for them or leave that up to the consumer.

Another good example is from the [Jenkins Cookbook Java recipe](https://github.com/opscode-cookbooks/jenkins/commit/ca2a69d982011dc1bec6a6d0ee4da5c1a1599864).

### Pinning to major version of cookbook and Java

This cookbook follows semver. It is recommended to pin at the major version of this cookbook when including it in other cookbooks, eg: `depends 'java', '~> 1.0'`

It is acceptable to set the `node['java']['jdk_version']` to a specific version if required for your software to run, eg software xyz requires Java 8 to run. Refrain from pinning to specific patches of the JDK to allow users to consume security updates.

## Development

This cookbook uses [test-kitchen](https://github.com/test-kitchen/test-kitchen) for integration tests and [ChefSpec/RSpec](https://github.com/sethvargo/chefspec) for unit tests. See [TESTING.md](https://github.com/agileorbit-cookbooks/java/blob/master/TESTING.md) for testing instructions.

At this time due to licensing concerns, the IBM recipe is not set up in test kitchen. If you would like to test this locally, copy .kitchen.yml to .kitchen.local.yml and add the following suite:

```yml
suites:
- name: ibm
  run_list: ["recipe[java]"]
  attributes:
    java:
      install_flavor: "ibm"
      ibm:
        accept_ibm_download_terms: true
        url: "http://jenkins/ibm-java-x86_64-sdk-7.0-4.1.bin"
        checksum: the-sha256-checksum
```

Log into the IBM DeveloperWorks site to download a copy of the IBM Java SDK you wish to use/test, host it on an internal HTTP server, and calculate the SHA256 checksum to use in the suite.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
