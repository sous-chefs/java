[back to resource list](https://github.com/sous-chefs/java#resources)

# openjdk_install

Introduced: v8.0.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type            | Default | Description                                         | Allowed values     |
| --------------------- | --------------- | ------- | --------------------------------------------------- | ------------------ |
| version               | String          |         | Java version to install                             |
| url                   | String          |         | The URL to download from                            |
| checksum              | String          |         | The checksum for the downloaded file                |
| java_home             | String          |         | Set to override the java_home                       |
| java_home_mode        | Integer, String |         | The permission for the Java home directory          |
| java_home_owner       | String          |         | Owner of the Java Home                              |
| java_home_group       | String          |         | Group for the Java Home                             |
| default               | Boolean         |         | Whether to set this as the defalut Java             |
| bin_cmds              | Array           |         | A list of bin_cmds based on the version and variant |
| alternatives_priority | Integer         |         | Alternatives priority to set for this Java          |
| reset_alternatives    | Boolean         |         | Whether to reset alternatives before setting        |
| pkg_names             | Array           |         | List of packages to install                         |
| pkg_version           | String          |         | Package version to install                          |
| install_type          | String          |         | Installation type                                   | `package` `source` |

## Examples

To install OpenJDK 11 and set it as the default Java

```ruby
openjdk_install '11'
```

To install OpenJDK 11 and set it as second highest priority

```ruby
openjdk_install '11' do
  alternatives_priority 2
end
```
