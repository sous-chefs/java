# temurin_package_install

Installs Java Temurin (AdoptOpenJDK) packages provided by Adoptium. This resource handles the repository setup and package installation for Temurin JDK packages across various platforms.

## Actions

- `:install` - Installs Temurin JDK packages
- `:remove` - Removes Temurin JDK packages

## Properties

| Property              | Type           | Default                                | Description                                  |
|-----------------------|----------------|----------------------------------------|----------------------------------------------|
| `version`             | String         | Name Property                          | Java version to install (e.g. '8', '11', '17') |
| `pkg_name`            | String         | `temurin-#{version}-jdk`               | Package name to install                      |
| `pkg_version`         | String         | `nil`                                  | Package version to install                   |
| `java_home`           | String         | Platform-specific JAVA_HOME            | Path to set as JAVA_HOME                     |
| `bin_cmds`            | Array          | Version-specific binary commands       | Commands for alternatives                    |
| `alternatives_priority` | Integer      | 1062                                   | Priority for alternatives system             |
| `reset_alternatives`  | Boolean        | true                                   | Whether to reset alternatives before setting |
| `default`             | Boolean        | true                                   | Whether to set this as the default Java      |

## Examples

### Install Temurin JDK 11

```ruby
temurin_package_install '11'
```

### Install Temurin JDK 17 with custom alternatives priority

```ruby
temurin_package_install '17' do
  alternatives_priority 1100
end
```

### Install specific version with custom package name

```ruby
temurin_package_install '11' do
  pkg_name 'temurin-11-jdk'
end
```

## Platform Support

This resource supports the following platforms:

- Debian
- Ubuntu
- RHEL/CentOS/Rocky Linux
- Fedora
- Amazon Linux
- OpenSUSE/SLES

Each platform will have the appropriate Adoptium repository configured automatically.

## Notes

- This resource uses the Adoptium API to validate available releases.
- The resource will warn if a requested version is not available as an LTS release.
- For most use cases, you can simply specify the major version number.
