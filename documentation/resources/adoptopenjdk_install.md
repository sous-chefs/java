[back to resource list](https://github.com/sous-chefs/java#resources)

# adoptopenjdk_install

Introduced: v7.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type            | Default                                  | Description                                         | Allowed Values                         |
| --------------------- | --------------- | ---------------------------------------- | --------------------------------------------------- |
| version               | String          |                                          | Java version to install                             |
| variant               | String          | `openj9`                                 | Install falvour                                     | `hotspot` `openj9` `openj9-large-heap` |
| url                   | String          | `default_adoptopenjdk_url(version)`      | The URL to download from                            |
| checksum              | String          | `default_adoptopenjdk_checksum(version)` | The checksum for the downloaded file                |
| java_home             | String          | Based on the version                     | Set to override the java_home                       |
| java_home_mode        | Integer, String | `0755`                                   | The permission for the Java home directory          |
| owner                 | String          | `root`                                   | Owner of the Java Home                              |
| group                 | String          | `node['root_group']`                     | Group for the Java Home                             |
| default               | Boolean         | `true`                                   | Whether to set this as the defalut Java             |
| bin_cmds              | Array           | `default_openjdk_bin_cmds(version)`      | A list of bin_cmds based on the version and variant |
| alternatives_priority | Integer         | `1`                                      | Alternatives priority to set for this Java          |
| reset_alternatives    | Boolean         | `true`                                   | Whether to reset alternatives before setting        |

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
