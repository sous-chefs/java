# Java Cookbook CHANGELOG

This file is used to list changes made in each version of the Java cookbook.

## 12.0.6 - *2024-07-15*

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

Standardise files with files in sous-chefs/repo-management

## 12.0.5 - *2024-05-03*

## 12.0.4 - *2024-05-03*

## 12.0.3 - *2024-01-16*

## 12.0.2 - *2024-01-16*

- Fix `openjdk_pkg_install` to obey `pkg_version` property for all `pkg_names`

## 11.2.2 - *2023-09-28*

## 11.2.1 - *2023-09-12*

## 11.2.0 - *2023-09-12*

## 11.1.14 - *2023-09-04*

## 11.1.13 - *2023-07-10*

## 11.1.12 - *2023-05-16*

## 11.1.11 - *2023-04-17*

Standardise files with files in sous-chefs/repo-management

## 11.1.10 - *2023-04-07*

Standardise files with files in sous-chefs/repo-management

## 11.1.9 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 11.1.8 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 11.1.7 - *2023-04-01*

Standardise files with files in sous-chefs/repo-management

## 11.1.6 - *2023-03-02*

Standardise files with files in sous-chefs/repo-management

## 11.1.5 - *2023-02-20*

Standardise files with files in sous-chefs/repo-management

## 11.1.4 - *2023-02-15*

Standardise files with files in sous-chefs/repo-management

## 11.1.3 - *2023-02-14*

Standardise files with files in sous-chefs/repo-management

## 11.1.2 - *2023-02-14*

## 11.1.1 - *2022-12-08*

Standardise files with files in sous-chefs/repo-management

## 11.1.0 - *2022-04-26*

- Remove Correto 15 and 16
- Add Corretto 17 and 18
- Change the defualt download URL for Corretto to the versioned resources URL, rather than latest.

## 11.0.2 - *2022-04-20*

- Standardise files with files in sous-chefs/repo-management

## 11.0.1 - *2022-02-16*

- Elevate permissions for reuable workflow

## 11.0.0 - *2022-02-16*

- Require Chef 16 for resource partials
- Add resource partials for: MacOS, Linux, Java Home and Common as these are used in a multiple places

## 10.2.2 - *2022-02-14*

- Standardise files with files in sous-chefs/repo-management

## 10.2.1 - *2022-02-02*

- Standardise files with files in sous-chefs/repo-management

## 10.2.0 - *2022-01-26*

- Remove tap_full option as this is no longer supported and there is no replacement

## 10.1.2 - *2022-01-26*

- Remove delivery and move to calling RSpec directly via a reusable workflow

## 10.1.1 - *2021-10-19*

Standardise files with files in sous-chefs/repo-management

## 10.1.0 - *2021-10-06*

- Revert worklfow split out
- Rename InSpec attribute folders to input
- Add Corretto 16
- Update the Corretto minor version numbers
- Default the Debian install method to package
- Remove testing for end of life OpenJDK suites
- Primarily support OpenJDK LTS versions 11, 17
- Drop support for OpenJDK package installs for non-LTS versions

  These packages are still possible to install though they will now default to a source install
- Direct Amazon users to Amazon Corretto instead of installing OpenJDK
- Drop package install support for Java 8. Most supported operating systems no longer support OpenJDK 8

  To install OpenJDK 8, a 'source' install from an internal mirror is now recommended

## 10.0.1 - *2021-09-21*

- Split out workflows to allow standardfiles to control markdown, yaml and delivery
- Adds a "Final" workflow to set a known pass/failure hook

  This allows us to have Terraform set the Final workflow as a required check

## 10.0.0 - *2021-09-02*

- Remove recipes to stop confusing users

## 9.0.1 - *2021-08-30*

- Standardise files with files in sous-chefs/repo-management

## 9.0.0 - *2021-06-04*

- Remove Corretto checksum code defualts as this changes reguarly,
    and is not provide in the SHA256 format via an API
- Set unified_mode to true for Chef 17 support
- Bump the minimum Chef version to 15.3 for unified_mode support

## 8.6.1 - *2021-06-01*

## 8.6.0 - *2021-01-22*

- Added Amazon Corretto 15 support to `corretto_install`
- Added configurable `file_cache_path` property to `java_certificate`
- Added `cacerts` property to `java_certificate` for interacting with java cacerts file (Java 9+)

## 8.5.0 - *2020-12-03*

- resolved cookstyle error: spec/spec_helper.rb:4:18 convention: `Style/RedundantFileExtensionInRequire`
- resolved cookstyle error: spec/spec_helper.rb:5:18 convention: `Style/RedundantFileExtensionInRequire`
- resolved cookstyle error: spec/spec_helper.rb:6:18 convention: `Style/RedundantFileExtensionInRequire`
- resolved cookstyle error: spec/spec_helper.rb:7:18 convention: `Style/RedundantFileExtensionInRequire`
- If installation issues with `openjdk_install` resource (fixes #645)
- Remove testing of Amazon Linux 1
- Use fedora-latest

## 8.4.0 (2020-09-09)

- Add `starttls` property to `java_certificate` resource to allow fetching certificates from non HTTPS endpoints

## 8.3.2 (2020-08-20)

- Add aarch64 installation candidate for Corretto

## 8.3.1 (2020-08-06)

- Extract correct JAVA_HOME from custom URLs

## 8.3.0 (2020-06-18)

- Restore compatibility with Chef Infra Client < 16
- Update Fedora releases in the Kitchen configs

## 8.2.1 (2020-06-02)

- resolved cookstyle error: resources/adoptopenjdk_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/adoptopenjdk_linux_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/adoptopenjdk_macos_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/corretto_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/openjdk_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/openjdk_pkg_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`
- resolved cookstyle error: resources/openjdk_source_install.rb:1:1 warning: `ChefDeprecations/ResourceUsesOnlyResourceName`

## 8.2.0 (2020-05-22)

- Fixed java_certificate resource :remove bugs preventing removal

## 8.1.2 (2020-04-20)

- Add OpenJDK source install resource
- Add documentation for openjdk_source_install
- Default the openjdk_install resource to install using the package manager by default

## 8.1.1 (2020-04-19)

- Fix JAVA_HOME for `adoptopenjdk_linux_install` resource

## 8.1.0 (2020-04-19)

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

## 8.0.1 (2020-03-30)

- Added documentation in documentation/resources for `adoptopenjdk_install`, `alternatives`, `certificate`, `corretto_install`, `jce`, `openjdk_install`

## 8.0.0 (2020-03-30)

- Added `openjdk_install` resource & documentation
- Removed openjdk, corretto, default_java_symlink, ibm & ibm_tar, notify & oracle recipes
- Removed support for IBM and Oracle Java
- Temporarily removed support for Windows
- Split out helpers for each provider into their own namespace and file

## 7.0.0 (2020-03-05)

- Refactored and sped up unit tests.
- Added `adoptopenjdk_install` resource & documentation
- Added AdoptOpenJDK 13 testing
- Removed the adoptopenjdk recipe, please use the `adoptopenjdk_install` resource instead.
- Increased the minimum Chef requirement to Chef 15 to use the archive resource.
- Removed AdoptOpenJDK 10 testing

## 6.0.0 (2020-03-02)

- The resource alias `java_ark` has been deprecated in favour of `java_oracle_install`

## 5.0.0 (2020-02-21)

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

## 4.3.0 (2019-08-04)

- Upgrade Amazon Corretto to the latest versions: 8.222.10.1 and 11.0.4.11.1
- Upgrade circleci orb to version 2 and add yamllint and markdown lint

## 4.2.0 - (2019-07-15)

- Fix for issue 538
- Added "download_path" node attribute defaulting to file_cache_path
- Replaced all hardcoded instances of file_cache_path with the node attribute

## 4.1.0 - (2019-05-08)

- Added new install flavor "corretto" for Amazon's Corretto distribution of OpenJDK

## 4.0.0 - (2019-04-19)

- Added new install flavor "adoptopenjdk" for AdoptOpenJDK's distribution of Java
- The certificate resource now uses the Java version to determine the default cacerts location
- Updated AdoptOpenJDK links for Java 8
- Updated AdoptOpenJDK links for Java 11 to 11.0.1
- BREAKING CHANGE: Remove support for Java 6 & 7
- Remove platform suport for untested platforms (smartOS, XenServer, zlinux, arch)
- Remove testing of Ubuntu 14.04, support at this point is no longer guaranteed and patches or other changes may not be accepted going further as Ubuntu 14.04 will be shortly EOL
- Fixed oracle download link for JDK 8 (update to 8u202 from 8u201)
- fixed specs for windows

## 3.2.0 - (2019-01-24)

- Add support OpenJDK 11
- Fixed oracle download link again

## 3.1.2 - (2018-12-11)

- Set java home on macosx using /usr/libexec/java_home
- Find command should have ./ for path to search, works for nix and mac
- Make `java_certificate` work with SNI endpoints

## 3.1.1 - (2018-11-09)

- Fix jce installation linux
- Allow overwrite `returns` property of windows_packages

## 3.1.0 - (2018-10-18)

- Add support for JDK 11

## 3.0.0 - (2018-10-18)

- Fix broken JCE with JRE installations
- make cert alias matching case insensitive as `keytool` always returns results downcases
- BREAKING CHANGE: fixed greedy matching by adding a word boundry when checking cert alias this prevents matching `foo_123` as `foo`
- verify artifact after downloading from oracle
- fixed `recipes/openjdk` when `node['java']['jdk_version']` by casting it to a string
- Updated Oracle Java links to 8u191

## 2.2.1 - (2018-09-29)

- Allows for additional Oracle (post 9) jdk download file naming, including '10.0.2'. '18.9', '11'

## 2.2.0 - (2018-07-19)

- Updated Oracle Java links to 8u181
- Fixed incorrect kitchen setup runlists that preventing local testing
- Resolve undefined certout errors

## 2.1.0 - (2018-05-25)

- Added Java 10 JCE attributes to default attrs
- Update oracle recipeM to not perform a switch on java major version and instead use the version provided in attributes. This allows end users to include new Java versions without the cookbook requiring an update each time a major version gets released
- Updated the oracle_install resource to pick up semantic versioning that Oracle has started using for Java 10+
- Updated the default attributes file to include x86_64 endpoint and checksum for Oracle Java 10\. The i586 version is not (yet) available.
- Fix JCE installation on Windows
- Avoid EmptyWindowsCommand error on Windows

## v2.0.1 - (2018-05-02)

- Fix java_certificate and java_oracle_install to work on FIPS enabled systems

## v2.0.0 - (2018-05-02)

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
- Deprecated the java::purge recipe which purged old Sun Java packages which were distributed in distro repos before the Oracle acquisition of Sun. Migration away from these packages occurred many years ago and this recipe will be removed in the next major release of this cookbook.
- Updated the metadata license string to an SPDX compliant string to resolve Foodcritic warnings.
- Removed Chef 10 compatibility code in the Windows recipe that resulted in Foodcritic warnings.
- Removed logic to support paths on Debian < 7 and Ubuntu < 12.04 as these are both EOL.
- Removed duplicate logging in the resources.
- Converted integration tests from bats to InSpec.
- Moved template files out of the default directory as
- Corrected deprecation warnings in the ChefSpecs.
- Moved all Kitchen testing logic to the test_java cookbook and eliminated the need for the apt & free_bsd bash cookbooks in testing
- Don't try to create Chef's cache directory in the certificate resource.
- Disabled certificate integration tests since we're not currently running the certificate resource in Test Kitchen.
- Removed testing of Oracle JDK 6/7 since Oracle no longer allows directly downloading these releases.
- Added kitchen-dokken based testing

## v1.50.0 - (05/24/2017)

- Oracle downloads changed again. Only Oracle 8 is able to be downloaded automatically. Please host your own copy internally to avoid issues such as this.
- Add Log warning if download url contains oracle.com

## v1.49.0 - (04/21/2017)

- potential 'curl' resource cloning #415
- Oracle 8u131
- Add ChefSpec matchers for java_certificate resource
- Remove unnecessary apt update

## v1.48.0 - (03/31/2017)

- Update Oracle Java links from 101 to 121
- Remove convergence report
- Remove Fedora 24 testing
- Fix test cookbook license
- Update platforms in the specs
- Remove testing on EOL platforms

## v1.47.0 - (01/30/2017)

- Fix typo in method name (#397)
- Remove useless ruby_block[set-env-java-home]
- Update README: using java::notify
- Add forgotten "do" to README

## v1.46.0 - (01/09/2017)

- fix jce installation on windows #386

## v1.45.0 - (12/27/2016)

- Update to resolve latest rubocop rules

## v1.44.0 - (12/27/2016)

- Unpublished due to newer rubocop rules in travis
- Added zlinux defaults

## v1.43.0 - (12/6/2016)

- Switch recursive chown from executing on the jdk parent directory to executing on the jdk directory itself.
- Added proxy support to curl
- add java_certificate LWRP from java-libraries cookbook - java-libraries now depricated.
- (Windows) support removal of obsolete JREs via optional attribute
- (Windows) Can download from s3 only using an IAM profile
- (Windows) aws session token for windows java download

## v1.42.0 - (8/8/2016)

- Use openjdk ppa for all ubuntu versions to allow for older/newer jdks to be installed. Fixes #368
- update oracle java 8u101 - Use sha256 hash (seems to help with downloading each converge)
- Mac default converge fails since notify is not included by homebrew
- Remove chef 14(!) depreciation warning in tests
- Resolve chef-12 related warning

## v1.41.0 - (7/15/2016)

- Feature: Add new resource for cookbooks to subscribe to, see README
- Use a remote_file resource for JCE download instead of curl in an execute block.
- Since v1.40.4 Travis deploys cookbook to supermarket - expect more frequent, smaller releases.

## v1.40.4 - (7/12/2016)

- Automated deploy, no cookbook changes.

## v1.40.3 - (7/12/2016)

- Attempt to have travis publish this.
- Mac depends on homebrew.
- Fixed typo in platform family spelling for OS X
- fix openjdk version logic for freebsd
- Enable Ark provider to handle URI with get parameters

## v1.40.1 - (7/8/2016)

- Fixed: JAVA_HOME not set on systems with restrictive umask #359

## v1.40 - (6/29/2016)

- Travis build green
- Add Windows JCE support
- Changes to prevent re-execution of resource creating file '/etc/profile.d/jdk.sh'
- Fix JDK checksum
- Update ibm_jdk.installer.properties.erb for IBM JDK 1.8
- Install OpenJDK from distribution if Ubuntu version >= 15.10
- Fixes #342 - Tar is included in macosx and homebrews package is gnutar which causes this to fail
- Add 12.04 to jdk8 test suite
- Add source and issues urls to supermarket
- Distinguishing the Java version for installing on the Mac OS X
- Doc and cruft cleanup

## v1.39 - (1/14/2016)

- Travis debugging only, no code changes.

## v1.38 - (1/13/2016)

- (Win) Fix for Java install failing on Windows (introduced in #315)
- Travis fixes/badge

## v1.37 - (11/9/2015)

- (Win) Attirbute for specifying the install directory for the public jre #315

## v1.36 - (9/3/2015)

- Oracle JDK 1.8.0_65
- Add Ubuntu ppa (allows OpenJDK 8)
- Added ChefSpec matchers #284
- Fix compile error using Chef::Application.fatal #279
- #222 Provide possibility to set ark download timeout
- Openjdk6 does not exist in deb 8.2
- Change to create java home dir even if top level doesn't exist(Eg mkdir_p instead of mkdir)
- Fix berks url and remove apt
- Documentation and dependency updates

## v1.35 - (8/4/2015)

- Use bento boxes and remove EOL distros from testing suite.
- Update to latest JDKs. Note Oracle JDK7 is now EOL.
- Alternatives improvements
- Fixes #155 to allow install of OpenJDK 1.8
- Fixes #257 Changed switches for the jdk 8 exe installer on windows
- Make sure tar package installed for java_ark
- Add support for Mac OS X "mac_os_x" via homebrew.
- Update metadata.rb to contain source and issue information for supermarket and chef-repo convenience

### Known Issues

- Kitchen CI test with 12.04 fails due to hostname unable to be set.

## v1.31 - (2/3/2015)

- Update to latest JDKs for 7 and 8\. JDK7 will be EOL April 2015
- Fix up Travis support.
- Add ability to install JCE policy files for oracle JDK #228
- Change connect timeout to 30 seconds

## v1.29.0 - (11/14/2014)

- Ensure dirs, links, and jinfo files are owned correctly
- Update to Oracle JDK 8u25
- Update to Oracle JDK 7u71-b14
- Adding a connect_timeout option for downloading java.
- Switched to chef-zero provisioner in test suites.
- Adding ISSUES.md for guidance on creating new issues for the Java cookbook.
- Fix IBM unit tests.

## v1.28.0 - (9/6/2014)

- Allow setting of group to extracted java files.
- Add -no-same-owner parameter to tar extract to avoid issues when the chef cache dir is on an NFS mounted drive.
- In the ark provider, it doesn't compare the MD5 sum with the right value which causes Java cookbook always download tarball from oracle server

## v1.27.0 - (8/22/2014)

- Update Oracle JDK8 to version 8u20

## v1.26.0 - (8/16/2014)

- Allow pinning of package versions for openjdk
- Update Oracle JDK7 to version 7u67
- Support specific version and name for Oracle RPM

## v1.25.0 - (8/1/2014)

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

## v1.24.0 - (7/25/2014)

New Cookbook maintainer! **[Agile Orbit](http://agileorbit.com)**

- Bump JDK7 URLs to 7u65
- Upgrade Oracle's Java 8 to u11
- Allow for alternatives priority to be set from attribute.
- Change ownership of extracted files
- Add retries and retry_delay parameters to java_ark LWRP
- default: don't fail when using java 8 on windows
- Support for Server JRE
- Updated README for accepting oracle terms
-Remove VirtualBox specific box_urls
- List AgileOrbit as the maintainer (AgileOrbit took over from Socrata in July 2014)

## v1.23.0 - (7/25/2014)

- Tagged but never published to community cookbooks. All changes rolled into 1.24.0

## v1.22.0

- Add support for Oracle JDK 1.8.0
- Make use of Chef's cache directory instead of /tmp
- Update Test Kitchen suites
- Add safety check for JDK 8 on non-Oracle

## v1.21.2

- Update Oracle accept-license-terms cookie format

## v1.21.0

- Symlink /usr/lib/jvm/default-java for both OpenJDK and Oracle
- Remove /var/lib/alternatives/#{cmd} before calling alternatives (Hopefully fixes sporadic issues when setting alternatives)
- Make default_java_symlink conditional on set_default attribute

## v1.20.0

- Create /usr/lib/jvm/default-java on Debian
- allow wrapping cookbook without providing templates
- Adds set_default attribute to toggle setting JDK as default
- set java_home correctly for oracle_rpm

## v1.19.2

- Upgrade to ChefSpec 3
- Rewrite unit tests for better coverage and to work with ChefSpec 3 (various commits)
- List Socrata as the maintainer (Socrata took over from Opscode in December 2013)
- Allow jdk_version to be a string or number
- Fix JDK install on Windows
- Fix openjdk_packages on Arch Linux
-

## v1.19.0

Refactor the cookbook to better support wrapper cookbooks and other cookbook authoring patterns.

- Update documentation & add warning for issue 122
- Refactor default recipe to better enable wrapper cookbooks
- Removes the attribute to purge deprecated packages
- Add safety check if attributes are unset
- Adds tests for directly using openjdk and oracle recipes
- Adds recipes to README
- The Opscode CCLA is no longer required
- Adds tests for openjdk-7 and oracle-7
- Use java_home instead of java_location for update-alternatives
- Fix java_home for rhel and fedora

## v1.18.0

- Upgrade to 7u51
- Suggest windows and aws

## v1.17.6

- Revert **[COOK-4165]** - The headers option was only added to remote_file in Chef 11.6.0, meaning this change breaks older clients.

## v1.17.4

- Fix alternatives for centos

- Replace curl with remote_file with cookie header
- Update openjdk to use the alternatives resource

## v1.17.2

- Add md5 parameter to java_ark resource

## v1.17.0

- Test Kitchen no longer works after merging Pull Request #95 for openjdk tests on Debian/Ubuntu
- update-alternatives fails to run
- Ensure local directory hierarchy
- Expose LWRP state attributes support for MD5 checksum
- Fixed windows case to prevent bad java_home variable setting
- Update checksums to the officially-published ones
- Further test kitchen fixes

## v1.16.4

- set alternatives when using ibm_tar recipe
- Specify windows attributes in attribute files

## v1.16.2

- set alternatives for ibm jdk
- IBM Java installer needs 'rpm' package on Ubuntu

- do not unescape the java windows url before parsing it
- fixes update-alternatives for openjdk installs
- Use escaped quotes for Windows INSTALLDIR

## v1.16.0

- Upgrade to JDK 7u45-b18

## v1.15.4

[COOK-4210] - remove unneeded run_command to prevent zombie processes

## v1.15.2

[CHEF-4210] remove unneeded run_command to prevent zombie processes

## v1.15.0

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
