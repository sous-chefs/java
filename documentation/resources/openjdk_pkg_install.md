
# openjdk_pkg_install

[back to resource list](https://github.com/sous-chefs/java#resources)

Installs OpenJDK Java packages from the system's package manager. This resource handles platform-specific package installation for OpenJDK across different Linux distributions and versions, and configures the alternatives system appropriately.

Introduced: v8.1.0

## Actions

- `:install`
- `:remove`

## Properties

| Name                  | Type    | Default                              | Description                                                             |
|-----------------------|---------|--------------------------------------|-------------------------------------------------------------------------|
| version               | String  |                                      | Java major version to install                                           |
| pkg_names             | Array   | `default_openjdk_pkg_names(version)` | List of packages to install                                             |
| pkg_version           | String  | `nil`                                | Package version to install                                              |
| java_home             | String  | Based on the version                 | Set to override the java_home                                           |
| default               | Boolean | `true`                               | Whether to set this as the default Java                                 |
| bin_cmds              | Array   | `default_bin_cmds(version)`          | A list of bin_cmds based on the version and variant                     |
| alternatives_priority | Integer | `1062`                               | Alternatives priority to set for this Java                              |
| reset_alternatives    | Boolean | `true`                               | Whether to reset alternatives before setting                            |
| skip_alternatives     | Boolean | `false`                              | Skip alternatives installation completely                               |
| repository_uri        | String  | `nil`                                | URI for the repository mirror to use instead of default repository URLs |

## Examples

To install OpenJDK 11 and set it as the default Java:

```ruby
openjdk_pkg_install '11'
```

To install OpenJDK 11 and set it as second highest priority:

```ruby
openjdk_pkg_install '11' do
  alternatives_priority 2
end
```

## Architecture Support

This resource supports installation on both x86_64 and ARM64 architectures. On ARM64 platforms (like ARM Macs or ARM-based cloud instances), package paths may include architecture-specific suffixes in paths (e.g., `-arm64` or `-aarch64`).
