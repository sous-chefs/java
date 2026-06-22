
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
| source_install_dir    | String          | Based on the archive name           | Source install directory                            |
| java_home_mode        | Integer, String | `0755`                              | The permission for the Java home directory          |
| java_home_owner       | String          | `root`                              | Owner of the Java Home                              |
| java_home_group       | String          | `node['root_group']`                | Group for the Java Home                             |
| default               | Boolean         | `true`                              | Whether to set this as the default Java             |
| bin_cmds              | Array           | `default_bin_cmds(version)`         | A list of bin_cmds based on the version and variant |
| alternatives_priority | Integer         | `1`                                 | Alternatives priority to set for this Java          |
| reset_alternatives    | Boolean         | `true`                              | Whether to reset alternatives before setting        |
| skip_alternatives     | Boolean         | `false`                             | Skip alternatives installation completely           |

## Examples

To install OpenJDK 11 and set it as the default Java:

```ruby
openjdk_source_install '11'
```

To install OpenJDK 11 and set it as second highest priority:

```ruby
openjdk_source_install '11' do
  alternatives_priority 2
end
```

To install a custom OpenJDK archive from an internal mirror:

```ruby
openjdk_source_install '17' do
  url 'https://artifacts.example.com/java/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
end
```

This installs to `/usr/lib/jvm/java-17-openjdk/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9`
and configures alternatives from that Java home.

To choose a stable install directory for a custom archive:

```ruby
openjdk_source_install '17' do
  url 'https://artifacts.example.com/java/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
  source_install_dir 'jdk-17.0.9+9'
end
```

Source archives must contain a single top-level directory. The resource extracts archives with
one leading path component stripped so the archive contents land directly in `java_home`.
