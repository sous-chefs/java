[back to resource list](https://github.com/sous-chefs/java#resources)

# openjdk_install

Introduced: v7.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type            | Default                             | Description                                         |
| --------------------- | --------------- | ----------------------------------- | --------------------------------------------------- |
| version               | String          |                                     | The name of the resource. java version to install   |
| java_home             | String          | Based on the version                | Set to override the java_home                       |
| url                   | String          | `default_openjdk_url(version)`      | The URL to download from                            |
| checksum              | String          | `default_openjdk_checksum(version)` | The checksum for the downloaded file                |
| java_home_mode        | Integer, String | 0755                                | The permission for the Java home directory          |
| bin_cmds              | Array           | `default_openjdk_bin_cmds(version)` | A list of bin_cmds based on the version and variant |
| owner                 | String          | `root`                              | Owner of the Java Home                              |
| group                 | String          | `node['root_group']`                | Group of the Java Home                              |
| default               | Boolean         | `true`                              | Whether to set this as the defalut Java             |
| alternatives_priority | Integer         | `1`                                 | Alternatives priority to set for this Java          |
| reset_alternatives    | Boolean         | `true`                              | Whether to reset alternatives before setting        |

## Examples

To install OpenJDK 11 and set it as the default Java

```ruby
openjdk_install '11'
```

To install OpenJDK 11 and set it as second highest priority

```ruby
openjdk_install '10' do
  alternatives_priority 2
end
```
