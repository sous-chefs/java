
# java_jce

[back to resource list](https://github.com/sous-chefs/java#resources)

`java_jce` installs the Java Cryptography Extension (JCE) policy files for a given Java installation.

## Actions

- `:install`: Installs the JCE policy files.
- `:remove`: Removes the staged JCE policy files, archive, and managed policy symlinks.

## Properties

| Name            | Type   | Default                                                  | Description                                                                |
| --------------- | ------ | -------------------------------------------------------- | -------------------------------------------------------------------------- |
| `jdk_version`   | String | Resource name                                            | The Java version to install into                                           |
| `jce_url`       | String | Required                                                 | The URL for the JCE distribution                                           |
| `jce_checksum`  | String | Required                                                 | The checksum of the JCE distribution                                       |
| `jce_cookie`    | String | `''`                                                     | Indicates that you accept Oracle's EULA                                    |
| `jce_home`      | String | `/usr/lib/jvm/jce`                                       | The location where JCE files will be decompressed for installation         |
| `java_home`     | String | Required                                                 | The location of the Java installation                                      |
| `principal`     | String | `administrator`                                          | For Windows installations only, this determines the owner of the JCE files |
| `download_path` | String | Chef file cache path                                     | Path used to stage the JCE archive                                         |
| `install_type`  | String | `jdk`                                                    | Whether the Java install is a jdk or jre layout                            |

## Examples

``` ruby
# Install the JCE for the default Java installation:
java_jce 'Install the JCE files'

# Install the JCE for a Java installation in /opt/tools/jdk8:
java_jce 'Install the JCE files' do
  java_home '/opt/tools/jdk8'
end

# Install the JCE for a Java 8 installation in /opt/tools/java using a custom download location:
java_jce 'Install the JCE files' do
  java_home '/opt/tools/java'
  jdk_version '8'
  jce_url 'https://artifacts/path/to/jce/policy.zip'
  jce_checksum 'deadbeefcafe...'
end
```
