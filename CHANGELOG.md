# Java Cookbook CHANGELOG

This file is used to list changes made in each version of the Java cookbook.

## 14.0.0 - *2025-07-16*

- Remove Semeru support as there is no clean yum or apt repository for it

## 13.2.0 - *2025-07-14*

- Add `repository_uri` property to `temurin_package_install` and `openjdk_pkg_install` resources to support installation from alternative/internal mirrors ([#728](https://github.com/sous-chefs/java/issues/728))
- Clarify documentation for `url` property in `openjdk_source_install` resource to note it can be used for internal mirrors
- Standardise files with files in sous-chefs/repo-management
  Update the recommended Ruby VSCode extensions
- Fix missing skip_alternatives property in openjdk_pkg_install

## 13.1.0 - *2025-07-14*

- add `skip_alternatives` to resources `corretto_install`, `openjdk_install`, `openjdk_pkg_install`, `openjdk_source_install` for cases when management of alternatives is not desired. (@dschlenk)

## 13.0.0 - *2025-07-13*

- Add new resource `temurin_package_install`
- Add script to check for Java updates
- Update Temurin Java 8 support
- Update Temurin repositories
- Update bin commands for all OpenJDK versions
- Fix Java alternatives to prevent unnecessary removal and re-addition of alternatives
- Move bin_cmds from Java::Cookbook::OpenJdkHelpers to Java::Cookbook::BinCmdHelpers for reuse outside of OpenJDK
- Fix apt_repository failing to install the GPG in the correct location
- Add Temurin 21 to the test matrix
- Remove Semeru from the test matrix

## 12.1.1 - *2024-12-05*

## 12.1.0 - *2024-12-03*

- Add support for OpenJDK versions 19, 20, 21 and 22
- Remove commented out `adoptopenjdk_linux_install` resource
- CI: chore(deps): update sous-chefs/.github action to v3.1.0
- CI: chore(deps): update actionshub/chef-install action to v3
- Update platforms
- Replace AdoptOpenJDK with Eclipse Temurin and IBM Semeru

## 12.0.7 - *2024-11-18*

- Standardise files with files in sous-chefs/repo-management

## 12.0.6 - *2024-07-15*

- Standardise files with files in sous-chefs/repo-management

## 12.0.2 - *2024-01-16*

- Fix `openjdk_pkg_install` to obey `pkg_version` property for all `pkg_names`

## 11.2.0 - *2023-09-12*

- Standardise files with files in sous-chefs/repo-management

## 11.1.0 - *2023-04-17*

- Standardise files with files in sous-chefs/repo-management

## 11.1.0 - *2022-04-26*

- Remove Correto 15 and 16
- Add Corretto 17 and 18
- Change the defualt download URL for Corretto to the versioned resources URL, rather than latest.

## 11.0.0 - *2022-02-16*

- Require Chef 16 for resource partials
- Add resource partials for: MacOS, Linux, Java Home and Common as these are used in a multiple places

## 10.2.0 - *2022-01-26*

- Remove tap_full option as this is no longer supported and there is no replacement
- Remove delivery and move to calling RSpec directly via a reusable workflow

## 10.1.0 - *2021-10-06*

- Revert worklfow split out
- Rename InSpec attribute folders to input
- Add Corretto 16
- Update the Corretto minor version numbers
- Default the Debian install method to package
- Remove testing for end of life OpenJDK suites
- Primarily support OpenJDK LTS versions 11, 17
- Drop support for OpenJDK package installs for non-LTS versions
- Direct Amazon users to Amazon Corretto instead of installing OpenJDK
- Drop package install support for Java 8

## 10.0.0 - *2021-09-02*

- Remove recipes to stop confusing users

## 9.0.0 - *2021-06-04*

- Remove Corretto checksum code defaults as this changes regularly, and is not provided in the SHA256 format via an API
- Set unified_mode to true for Chef 17 support
- Bump the minimum Chef version to 15.3 for unified_mode support

## 8.6.0 - *2021-01-22*

- Added Amazon Corretto 15 support to `corretto_install`
- Added configurable `file_cache_path` property to `java_certificate`
- Added `cacerts` property to `java_certificate` for interacting with java cacerts file (Java 9+)

## 8.5.0 - *2020-12-03*

- If installation issues with `openjdk_install` resource (fixes #645)
- Remove testing of Amazon Linux 1
- Use fedora-latest

## 8.4.0 - *2020-09-09*

- Add `starttls` property to `java_certificate` resource to allow fetching certificates from non HTTPS endpoints

## 8.3.2 - *2020-08-20*

- Add aarch64 installation candidate for Corretto

## 8.3.1 - *2020-08-06*

- Extract correct JAVA_HOME from custom URLs

## 8.3.0 - *2020-06-18*

- Restore compatibility with Chef Infra Client < 16
- Update Fedora releases in the Kitchen configs

## 8.2.0 - *2020-06-02*

- resolved cookstyle error: resources/adoptopenjdk_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- Remove testing of Ubuntu 14.04, support at this point is no longer guaranteed

## 8.1.0 - *2020-04-19*

- Added `openjdk_pkg_install` resource
- Added documentation for openjdk_pkg_install
- Added `adoptopenjdk_linux_install` resource
- Added `adoptopenjdk_macos_install` resource
- Added documentation for `adoptopenjdk_linux_install`
- Added documentation for `adoptopenjdk_macos_install`
- Resolved cookstyle error: resources/alternatives.rb:49:13 refactor: `ChefCorrectness/ChefApplicationFatal`
- Resolved cookstyle error: resources/alternatives.rb:62:13 refactor: `ChefCorrectness/ChefApplicationFatal`
- Resolved cookstyle error: resources/alternatives.rb:75:11 refactor: `ChefCorrectness/ChefApplicationFatal`
- Resolved cookstyle error: resources/jce.rb:51:6 refactor: `ChefStyle/UnnecessaryOSCheck`

## 8.0.0 - *2020-03-30*

- Added `openjdk_install` resource & documentation
- Removed openjdk, corretto, default_java_symlink, ibm & ibm_tar, notify & oracle recipes
- Removed support for IBM and Oracle Java
- Temporarily removed support for Windows
- Split out helpers for each provider into their own namespace and file

## 7.0.0 - *2020-03-05*

- Refactored and sped up unit tests.
- Added `adoptopenjdk_install` resource & documentation
- Added AdoptOpenJDK 13 testing
- Removed the adoptopenjdk recipe, please use the `adoptopenjdk_install` resource instead.
- Increased the minimum Chef requirement to Chef 15 to use the archive resource.
- Removed AdoptOpenJDK 10 testing

## 6.0.0 - *2020-03-02*

- The resource alias `java_ark` has been deprecated in favour of `java_oracle_install`

## 5.0.0 - *2020-02-21*

- Fixed java_certificate regex where it checks if cert exists in cacert file.
- Make Homebrew Cask name an attribute to allow for other options (ex: adoptopenjdk)
- Switch homebrew tap to homebrew/cask-versions
- Make builds parallel
- Updates package name and link changes for adoptopenjdk
- Migrated testing to github actions
- Removes openjdk-6
- Removes openjdk-7 for Ubuntu 16.04
- Removes openjdk-11 for Ubuntu
- Removes openjdk-direct for Debian 8
- Removes oracle variants from test configurations

## 4.3.0 - *2019-08-04*

- Upgrade Amazon Corretto to the latest versions: 8.222.10.1 and 11.0.4.11.1
- Upgrade circleci orb to version 2 and add yamllint and markdown lint

## 4.2.0 - *2019-07-15*

- Fix for issue 538
- Added "download_path" node attribute defaulting to file_cache_path
- Replaced all hardcoded instances of file_cache_path with the node attribute

## 4.1.0 - *2019-05-08*

- Added new install flavor "corretto" for Amazon's Corretto distribution of OpenJDK

## 4.0.0 - *2019-04-19*

- Added new install flavor "adoptopenjdk" for AdoptOpenJDK's distribution of Java
- The certificate resource now uses the Java version to determine the default cacerts location
- Updated AdoptOpenJDK links for Java 8
- Updated AdoptOpenJDK links for Java 11 to 11.0.1
- BREAKING CHANGE: Remove support for Java 6 & 7
- Remove platform suport for untested platforms (smartOS, XenServer, zlinux, arch)
- Remove testing of Ubuntu 14.04, support at this point is no longer guaranteed and patches or other changes may not be accepted going further as Ubuntu 14.04 will be shortly EOL
- Fixed oracle download link for JDK 8 (update to 8u202 from 8u201)
- fixed specs for windows

## 3.2.0 - *2019-01-24*

- Add support OpenJDK 11
- Fixed oracle download link again

## 3.1.2 - *2018-12-11*

- Set java home on macosx using /usr/libexec/java_home
- Find command should have ./ for path to search, works for nix and mac
- Make `java_certificate` work with SNI endpoints

## 3.1.1 - *2018-11-09*

- Fix jce installation linux
- Allow overwrite `returns` property of windows_packages

## 3.1.0 - *2018-10-18*

- Add support for JDK 11

## 3.0.0 - *2018-10-18*

- Fix broken JCE with JRE installations
- make cert alias matching case insensitive as `keytool` always returns results downcases
- BREAKING CHANGE: fixed greedy matching by adding a word boundry when checking cert alias this prevents matching `foo_123` as `foo`
- verify artifact after downloading from oracle
- fixed `recipes/openjdk` when `node['java']['jdk_version']` by casting it to a string
- Updated Oracle Java links to 8u191

## 2.2.1 - *2018-09-29*

- Allows for additional Oracle (post 9) jdk download file naming, including '10.0.2'. '18.9', '11'

## 2.2.0 - *2018-07-19*

- Updated Oracle Java links to 8u181
- Fixed incorrect kitchen setup runlists that preventing local testing
- Resolve undefined certout errors

## 2.1.0 - *2018-05-25*

- Added Java 10 JCE attributes to default attrs
- Update oracle recipeM to not perform a switch on java major version and instead use the version provided in attributes. This allows end users to include new Java versions without the cookbook requiring an update each time a major version gets released
- Updated the oracle_install resource to pick up semantic versioning that Oracle has started using for Java 10+
- Updated the default attributes file to include x86_64 endpoint and checksum for Oracle Java 10\. The i586 version is not (yet) available.
- Fix JCE installation on Windows
- Avoid EmptyWindowsCommand error on Windows

## v2.0.1 - *2018-05-02*

- Fix java_certificate and java_oracle_install to work on FIPS enabled systems

## v2.0.0 - *2018-05-02*

- Converted alternatives, ark, and certificate LWRP/HWRPs to custom resources with improved logging and convergence notification.
- Renamed the java_ark resource to java_oracle_install, which better represents what it does. The existing name will continue to function
- Removed the need for the apt cookbook and instead require Chef 12.9+
- Fixed Amazon Linux support on Chef 13+.
- Fixed the alternatives commands on Fedora systems.
- Added initial openSUSE leap support.
- Updated code to use multi-package installs to speed up runs
- Made the 'cert_alias' property in the certificate resource the name_property to allow users to avoid resource cloning and to be able to use friendly resource names
- Moved the warning code for downloading directly from Oracle into the resource to prevent another resource showing as converged
- Updated the metadata to resolve failures to parse chef_version on older chef-client releases.
- Added installation of tar directly to the ark resource when uncompression .tar.gz files. This prevents installation in the recipe that occurred even if tar wasn't needed.
- Add support for Mac OS X "mac_os_x" via homebrew.
- Update metadata.rb to contain source and issue information for supermarket and chef-repo convenience

### Known Issues

- Kitchen CI test with 12.04 fails due to hostname unable to be set.

## v1.31 - *2/3/2015*

- Update to latest JDKs for 7 and 8\. JDK7 will be EOL April 2015
- Fix up Travis support.
- Add ability to install JCE policy files for oracle JDK #228
- Change connect timeout to 30 seconds

## v1.29.0 - *11/14/2014*

- Ensure dirs, links, and jinfo files are owned correctly
- Update to Oracle JDK 8u25
- Update to Oracle JDK 7u71-b14
- Adding a connect_timeout option for downloading java.
- Switched to chef-zero provisioner in test suites.
- Adding ISSUES.md for guidance on creating new issues for the Java cookbook.
- Fix IBM unit tests.

## v1.28.0 - *9/6/2014*

- Allow setting of group to extracted java files.
- Add -no-same-owner parameter to tar extract to avoid issues when the chef cache dir is on an NFS mounted drive.
- In the ark provider, it doesn't compare the MD5 sum with the right value which causes Java cookbook always download tarball from oracle server

## v1.27.0 - *8/22/2014*

- Update Oracle JDK8 to version 8u20

## v1.26.0 - *8/16/2014*

- Allow pinning of package versions for openjdk
- Update Oracle JDK7 to version 7u67
- Support specific version and name for Oracle RPM

## v1.25.0 - *8/1/2014*

- Resource ark -> attribute bin_cmds default value
- Add option to put JAVA_HOME in /etc/environment
- Allow ark to pull from http and files ending in .gz.
- Recommendations for inclusion in community cookbooks
- Production Deployment with Oracle Java
- Update testing instructions for chefdk
- Various Readme formatting.
- Use Supermarket endpoint in berksfile
- rspec cleanup
- Adding ubuntu-14.04 to test suite

## v1.24.0 - *7/25/2014*

New Cookbook maintainer! **[Agile Orbit](http://agileorbit.com)**

- Bump JDK7 URLs to 7u65
- Upgrade Oracle's Java 8 to u11
- Allow for alternatives priority to be set from attribute.
- Change ownership of extracted files
- Add retries and retry_delay parameters to java_ark LWRP
- default: don't fail when using java 8 on windows
- Support for Server JRE
- Updated README for accepting oracle terms
- Remove VirtualBox specific box_urls
- List AgileOrbit as the maintainer (AgileOrbit took over from Socrata in July 2014)

## v1.23.0 - *7/25/2014*

- Tagged but never published to community cookbooks. All changes rolled into 1.24.0

## v1.22.0

- Add support for Oracle JDK 1.8.0
- Make use of Chef's cache directory instead of /tmp
- Update Test Kitchen suites
- Add safety check for JDK 8 on non-Oracle

## v1.21.2

[COOK-4210] - remove unneeded run_command to prevent zombie processes

## v1.21.0

- Update Oracle accept-license-terms cookie format

## v1.20.0

- Fixing version number. Accidently released at 0.15.x instead of 1.15.x

## v0.15.2

### FIX

- Fixing JAVA_HOME on Ubuntu 10.04

## v1.14.0

- Fix alternatives when the package is already installed
- Fix a condition that would result in an error executing action `run` on resource 'bash[update-java-alternatives]'
- Fix bad checksum length
- Fix an issue where Java cookbook installs both JDK 6 and JDK 7 when JDK 7 is specified
- Allow Windoes recipe to download from signed S3 url
- Fix a failure on Centos 6.4 and Oracle JDK 7
- Improve Windows support

## v1.13.0

- Add default `platform_family` option in Java helper
- Fix support for Fedora
- Upgrade to Oracle Java 7u25
- Add Oracle RPM support
- Add support for the platform `xenserver`
- Add SmartOS support

## v1.12.0

- Add SmartOS support to java::openjdk recipe
- upgrade to Oracle Java 7u25
- Adding support for the platform 'xenserver' (for installations of java in DOM0)
- java cookbook fails on Fedora

## v1.11.6

- Java cookbook does not have opensuse support
- Syntax Errors spec/default_spec.rb:4-8

## v1.11.4

- `bash[update-java-alternatives]` resource uses wrong attribute

## v1.11.2

- Use SHA256 checksums for Oracle downloads, not SHA1.

## v1.11.0

This version brings a wealth of tests and (backwards-compatible) refactoring, plus some new features (updated Java, IBM recipe).

- Add ibm recipe to java cookbook
- move java_home resources to their own recipe
- refactor ruby_block "update-java-alternatives"
- use platform_family in java cookbook
- add chefspec to java cookbook
- Refactor java cookbook
- update JDK to JDK 7u21, 6u45

## v1.10.2

- [2415] - Fixed deprecation warnings in ark provider and openjdk recipe by using Chef::Mixin::ShellOut instead of Chef::ShellOut

## v1.10.0

- Allow java ark :url to be https
- Upgrade needed for oracle jdk in java cookbook

## v1.9.6

- add support for Oracle Linux

## v1.9.4

- Run set-env-java-home in Java cookbook only if necessary
- ark provider does not allow for *.tgz tarballs to be used
- Java cookbook fails on CentOS6 (update-java-alternatives)

## v1.9.2

- FoodCritic fixes for java cookbook

## v1.9.0

- Update the Oracle Java version in the Java cookbook to release 1.7u11

## v1.8.2

- Fix for missing /usr/lib/jvm/default-java on Debian

## v1.8.0

- Add windows support

## v1.7.0

- improvements for Oracle update-alternatives
- When installing an Oracle JDK it is now registered with a higher priority than OpenJDK. (Related to COOK-1131.)
- When running both the oracle and oracle_i386 recipes, alternatives are now created for both JDKs.
- Alternatives are now created for all binaries listed in version specific attributes. (Related to COOK-1563 and COOK-1635.)
- When installing Oracke JDKs on Ubuntu, create .jinfo files for use with update-java-alternatives. Commands to set/install alternatives now only run if needed.

## v1.6.4

- fixed typo in attribute for java 5 on i586

## v1.6.2

- whyrun support in `java_ark` LWRP
- CHEF-1804 compatibility
- install Java 6u37 and Java 7u9
- incorrect warning text about `node['java']['oracle']['accept_oracle_download_terms']`

## v1.6.0

- Install Oracle JDK from Oracle download directly
- set JAVA_HOME in openjdk recipe
- Install correct architecture on Amazon Linux

## v1.5.4

update alternatives called on wrong file
use shellout instead of execute resource to update alternatives

## v1.5.2

- remove sun-java6-jre on Ubuntu before installing Oracle's Java
- fails on Ubuntu 12.04 64bit with openjdk7
- Oracle Java should symlink the jar command

## v1.5.0

- Oracle now prevents download of JDK via non-browser
- fix File.exists?

## v1.4.2

- fix attributes typo and platform case switch consistency

## v1.4.0

- numerous updates: handle jdk6 and 7, switch from sun to oracle, make openjdk default, add `java_ark` LWRP.
- [42] - FreeBSD support
- ArchLinux support
