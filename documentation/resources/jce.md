[back to resource list](https://github.com/sous-chefs/java#resources)

# java_jce

`java_jce` installs the Java Cryptography Extension (JCE) policy files for a given Java installation.

## Actions

- `:install`: Installs the JCE policy files.

## Properties

| Name           | Type   | Default                                                  | Description                                                                |
| -------------- | ------ | -------------------------------------------------------- | -------------------------------------------------------------------------- |
| `jdk_version`  | String | `node['java']['jdk_version']`                            | The Java version to install into                                           |
| `jce_url`      | String | `node['java']['oracle']['jce'][jdk_version]['url']`      | The URL for the JCE distribution                                           |
| `jce_checksum` | String | `node['java']['oracle']['jce'][jdk_version]['checksum']` | The checksum of the JCE distribution                                       |
| `jce_cookie`   | String | `node['java']['oracle']['accept_oracle_download_terms']` | Indicates that you accept Oracle's EULA                                    |
| `jce_home`     | String | `node['java']['oracle']['jce']['home']`                  | The location where JCE files will be decompressed for installation         |
| `java_home`    | String | `node['java']['java_home']`                              | The location of the Java installation                                      |
| `principal`    | String | `node['java']['windows']['owner']`                       | For Windows installations only, this determines the owner of the JCE files |

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
