
# openjdk_source_install

[back to resource list](https://github.com/sous-chefs/java#resources)

Installs OpenJDK Java from source archives. This resource handles downloading, extracting, and configuring OpenJDK from source tarballs, including setting up the Java home directory and alternatives system entries.

Introduced: v8.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type            | Default                             | Description                                         |
| --------------------- | --------------- | ----------------------------------- | --------------------------------------------------- |
| version               | String          |                                     | Java version to install                             |
| url                   | String          | `default_openjdk_url(version)`      | The URL to download from                            |
| checksum              | String          | `default_openjdk_checksum(version)` | The checksum for the downloaded file                |
| java_home             | String          | Based on the version                | Set to override the java_home                       |
| java_home_mode        | Integer, String | `0755`                              | The permission for the Java home directory          |
| java_home_owner       | String          | `root`                              | Owner of the Java Home                              |
| java_home_group       | String          | `node['root_group']`                | Group for the Java Home                             |
| default               | Boolean         | `true`                              | Whether to set this as the default Java             |
| bin_cmds              | Array           | `default_bin_cmds(version)` | A list of bin_cmds based on the version and variant |
| alternatives_priority | Integer         | `1`                                 | Alternatives priority to set for this Java          |
| reset_alternatives    | Boolean         | `true`                              | Whether to reset alternatives before setting        |
| skip_alternatives     | Boolean         | `false`                             | Skip alternatives installation completely           |

## Examples

To install OpenJDK 11 and set it as the default Java:

```ruby
openjdk_install '11'
```

To install OpenJDK 11 and set it as second highest priority:

```ruby
openjdk_install '11' do
  alternatives_priority 2
end
```
