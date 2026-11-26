
# openjdk_install

[back to resource list](https://github.com/sous-chefs/java#resources)

Installs OpenJDK Java via source or package manager. This resource selects the appropriate installation method based on the `install_type` property and handles cross-platform Java installation including alternatives configuration.

Introduced: v8.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type            | Default | Description                                         | Allowed values     |
| --------------------- | --------------- | ------- | --------------------------------------------------- | ------------------ |
| version               | String          |         | Java version to install                             |                    |
| url                   | String          |         | The URL to download from                            |                    |
| checksum              | String          |         | The checksum for the downloaded file                |                    |
| java_home             | String          |         | Set to override the java_home                       |                    |
| java_home_mode        | Integer, String |         | The permission for the Java home directory          |                    |
| java_home_owner       | String          |         | Owner of the Java Home                              |                    |
| java_home_group       | String          |         | Group for the Java Home                             |                    |
| default               | Boolean         |         | Whether to set this as the default Java             |                    |
| bin_cmds              | Array           |         | A list of bin_cmds based on the version and variant |                    |
| alternatives_priority | Integer         |         | Alternatives priority to set for this Java          |                    |
| reset_alternatives    | Boolean         |         | Whether to reset alternatives before setting        |                    |
| skip_alternatives     | Boolean         | `false` | Skip alternatives installation completely           |                    |
| pkg_names             | Array           |         | List of packages to install                         |                    |
| pkg_version           | String          |         | Package version to install                          |                    |
| install_type          | String          |         | Installation type                                   | `package` `source` |
| source_install_dir    | String          |         | Source install directory                            |                    |

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

To install a source archive from an internal mirror:

```ruby
openjdk_install '17' do
  install_type 'source'
  url 'https://artifacts.example.com/java/OpenJDK17U-jdk_x64_linux_hotspot_17.0.9_9.tar.gz'
  checksum 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
end
```

For source installs, custom URLs install into a directory derived from the archive name unless
`java_home` or `source_install_dir` is set. Source archives must contain a single top-level
directory because the source installer strips one leading path component during extraction.
