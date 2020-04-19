[back to resource list](https://github.com/sous-chefs/java#resources)

# adoptopenjdk_linux_install

Introduced: v8.1.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type          | Default                                                                | Description                                           |
| --------------------- | ------------- | ---------------------------------------------------------------------- | ----------------------------------------------------- |
| variant               | String        | `openj9`                                                               | Install flavour                                       |
| url                   | String        | `default_adopt_openjdk_url(version)[variant]`                          | The URL to download from                              |
| checksum              | String        | `default_adopt_openjdk_checksum(version)[variant]`                     | The checksum for the downloaded file                  |
| java_home             | String        | `/usr/lib/jvm/java-#{version}-adoptopenjdk-#{variant}/#{sub_dir(url)}` | Set to override the java_home                         |
| java_home_mode        | String        |                                                                        | Owner of the Java Home                                |
| java_home_group       | String        | `node['root_group']`                                                   | Group for the Java Home                               |
| default               | [true, false] | `true`                                                                 | Whether to set this as the defalut Java               |
| bin_cmds              | Array         | `default_adopt_openjdk_bin_cmds(version)[variant]`                     | A list of `bin_cmds` based on the version and variant |
| alternatives_priority | Integer       | `1`                                                                    | Alternatives priority to set for this Java            |
| reset_alternatives    | [true, false] | `true`                                                                 | Whether to reset alternatives before setting          |

## Examples

To install Hotspot AdoptOpenJDK 11 and set it as the default Java

```ruby
adoptopenjdk_linux_install1 '11'
```

To install hotspot AdoptOpenJDK 11 and set it as second highest priority

```ruby
adoptopenjdk_linux_install1 '10' do
  variant 'hotspot'
  alternatives_priority 2
end
```
