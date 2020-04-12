resource_name :adoptopenjdk_macos_install
include Java::Cookbook::AdoptOpenJdkMacOsHelpers

property :tap_full, [true, false], default: true, description: 'Perform a full clone on the tap, as opposed to a shallow clon.'
property :tap_url, String, description: 'The URL of the tap'
property :cask_options, String, description: 'Options to pass to the brew command during installation'
property :homebrew_path, String, description: 'The path to the homebrew binary'
property :owner, [String, Integer], description: 'The owner of the Homebrew installation'
property :java_home, String, default: lazy { macos_java_home(version) }, description: 'MacOS specific JAVA_HOME'
property :version, String,
         default: 'adoptopenjdk14',
         regex: /adoptopenjdk\d{1,2}(-openj9)?(-large)?|(-jre?)(-large)?/

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

  node.default['java']['home'] = new_resource.java_home
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
