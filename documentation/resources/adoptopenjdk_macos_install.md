[back to resource list](https://github.com/sous-chefs/java#resources)

# adoptopenjdk_macos_install

Introduced: v8.1.0

## Actions

- `:install`
- `:remove`

## Properties

| Name          | Type              | Default                    | Description                                                    | Allowed Values |
| ------------- | ----------------- | -------------------------- | -------------------------------------------------------------- |
| tap_full      | [true, false]     | `true`                     | Perform a full clone on the tap, as opposed to a shallow clone |
| tap_url       | String            |                            | The URL of the tap                                             |
| cask_options  | String            |                            | Options to pass to the brew command during installation        |
| homebrew_path | String            |                            | The path to the homebrew binary                                |
| owner         | [String, Integer] |                            | The owner of the Homebrew installation                         |
| java_home     | String            | `macos_java_home(version)` | MacOS specific JAVA_HOME                                       |
| version       | String            | `adoptopenjdk14`           |                                                                | See list below |

## Allowed Install Versions

- adoptopenjdk8
- adoptopenjdk8-openj9
- adoptopenjdk8-openj9-large
- adoptopenjdk8-jre
- adoptopenjdk8-openj9-jre
- adoptopenjdk8-jre-large
- adoptopenjdk9
- adoptopenjdk10
- adoptopenjdk11
- adoptopenjdk11-openj9
- adoptopenjdk11-openj9-large
- adoptopenjdk11-jre
- adoptopenjdk11-openj9-jre
- adoptopenjdk11-openj9-jre-large
- adoptopenjdk12
- adoptopenjdk12-openj9
- adoptopenjdk12-openj9-large
- adoptopenjdk12-jre
- adoptopenjdk12-openj9-jre
- adoptopenjdk12-openj9-jre-large
- adoptopenjdk13
- adoptopenjdk13-openj9
- adoptopenjdk13-openj9-large
- adoptopenjdk13-jre
- adoptopenjdk13-openj9-jre
- adoptopenjdk13-openj9-jre-large
- adoptopenjdk14
- adoptopenjdk14-openj9
- adoptopenjdk14-openj9-large
- adoptopenjdk14-jre
- adoptopenjdk14-openj9-jre
- adoptopenjdk14-openj9-jre-large

## Examples

To install Hotspot AdoptOpenJDK 11 and set it as the default Java

```ruby
adoptopenjdk_macos_install 'adoptopenjdk14-jre'
```
