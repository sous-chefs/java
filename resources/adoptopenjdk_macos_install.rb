provides :adoptopenjdk_macos_install
unified_mode true
include Java::Cookbook::AdoptOpenJdkMacOsHelpers

property :tap_full, [true, false],
  default: true,
  description: 'Perform a full clone on the tap, as opposed to a shallow clone'

property :tap_url, String,
  description: 'The URL of the tap'

property :cask_options, String,
  description: 'Options to pass to the brew command during installation'

property :homebrew_path, String,
  description: 'The path to the homebrew binary'

property :owner, [String, Integer],
  description: 'The owner of the Homebrew installation'

property :java_home, String,
  default: lazy { macos_java_home(version) },
  description: 'MacOS specific JAVA_HOME'

property :version, String,
  default: 'adoptopenjdk14',
  equal_to: %w(
    adoptopenjdk8 adoptopenjdk8-openj9 adoptopenjdk8-openj9-large
    adoptopenjdk8-jre adoptopenjdk8-openj9-jre adoptopenjdk8-jre-large
    adoptopenjdk9 adoptopenjdk10
    adoptopenjdk11 adoptopenjdk11-openj9 adoptopenjdk11-openj9-large
    adoptopenjdk11-jre adoptopenjdk11-openj9-jre adoptopenjdk11-openj9-jre-large
    adoptopenjdk12 adoptopenjdk12-openj9 adoptopenjdk12-openj9-large
    adoptopenjdk12-jre adoptopenjdk12-openj9-jre adoptopenjdk12-openj9-jre-large
    adoptopenjdk13 adoptopenjdk13-openj9 adoptopenjdk13-openj9-large
    adoptopenjdk13-jre adoptopenjdk13-openj9-jre adoptopenjdk13-openj9-jre-large
    adoptopenjdk14 adoptopenjdk14-openj9 adoptopenjdk14-openj9-large
    adoptopenjdk14-jre adoptopenjdk14-openj9-jre adoptopenjdk14-openj9-jre-large
  )

action :install do
  homebrew_tap 'AdoptOpenJDK/openjdk' do
    full               new_resource.tap_full
    homebrew_path      new_resource.homebrew_path
    owner              new_resource.owner
    url                new_resource.tap_url
    action             :tap
  end

  homebrew_cask "AdoptOpenJDK/openjdk/#{new_resource.version}" do
    homebrew_path      new_resource.homebrew_path
    install_cask       true
    options            new_resource.cask_options
    owner              new_resource.owner
    action             :install
  end

  # Bash system wide environment variables
  append_if_no_line 'Java Home' do
    path '/etc/profile'
    line "export JAVA_HOME=#{new_resource.java_home}"
  end

  # Zsh system wide environment variables
  append_if_no_line 'Java Home' do
    path '/etc/zshrc'
    line "export JAVA_HOME=#{new_resource.java_home}"
  end

  node.default['java']['java_home'] = new_resource.java_home
end

action :remove do
  homebrew_tap 'AdoptOpenJDK/openjdk' do
    homebrew_path      new_resource.homebrew_path
    owner              new_resource.owner
    action :untap
  end

  homebrew_cask "adoptopenjdk#{new_resource.version}" do
    homebrew_path      new_resource.homebrew_path
    options            new_resource.cask_options
    owner              new_resource.owner
    action             :remove
  end
end
