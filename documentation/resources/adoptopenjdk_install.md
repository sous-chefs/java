[back to resource list](https://github.com/sous-chefs/java#resources)

# adoptopenjdk_install

Introduced: v7.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type              | Default | Description                                                    |
| --------------------- | ----------------- | ------- | -------------------------------------------------------------- |
| version               | String            |         | Java version to install                                        |
| variant               | String            |         | Install flavour', default: 'openj9                             |
| url                   | String            |         | The URL to download from                                       |
| checksum              | String            |         | The checksum for the downloaded file                           |
| java_home             | String            |         | Set to override the java_home                                  |
| java_home_mode        | String            |         | The permission for the Java home directory                     |
| java_home_owner       | String            |         | Owner of the Java Home                                         |
| java_home_group       | String            |         | Group for the Java Home                                        |
| default               | [true, false]     |         | Whether to set this as the defalut Java                        |
| bin_cmds              | Array             |         | A list of bin_cmds based on the version and variant            |
| alternatives_priority | Integer           |         | Alternatives priority to set for this Java                     |
| reset_alternatives    | [true, false]     |         | Whether to reset alternatives before setting                   |
| tap_full              | [true, false]     | `true`  | Perform a full clone on the tap, as opposed to a shallow clone |
| tap_url               | String,           |         | The URL of the tap                                             |
| cask_options          | String,           |         | Options to pass to the brew command during installation        |
| homebrew_path         | String,           |         | The path to the homebrew binary                                |
| owner                 | [String, Integer] |         | The owner of the Homebrew installation                         |

## Examples

To install Hotspot AdoptOpenJDK 11 and set it as the default Java

```ruby
adoptopenjdk_install '11'
```

To install hotspot AdoptOpenJDK 11 and set it as second highest priority

```ruby
adoptopenjdk_install '10' do
  variant 'hotspot'
  alternatives_priority 2
end
```
