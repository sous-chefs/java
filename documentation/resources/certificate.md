[back to resource list](https://github.com/sous-chefs/java#resources)

# java_certificate

Java certificate simplifies adding certificates to a java keystore.
It can also populate the keystore with a certificate retrieved from a given SSL end-point.

## Actions

- `:install`: installs a certificate.
- `:remove`: removes a certificate.

## Properties

| Name              | Type   | Default                     | Description                                                                             |
| ----------------- | ------ | --------------------------- | --------------------------------------------------------------------------------------- |
| `java_home`       |        | node['java']['java_home']   | The java home directory                                                                 |
| `java_version`    |        | node['java']['jdk_version'] | The java version                                                                        |
| `keystore_path`   | String |                             | Path to the keystore                                                                    |
| `keystore_passwd` | String | `changeit`                  | Password to the keystore                                                                |
| `cert_alias`      | String |                             | The alias of the certificate in the keystore. This defaults to the name of the resource |
| `cert_data`       | String |                             | The certificate data to install                                                         |
| `cert_file`       | String |                             | Path to a certificate file to install                                                   |
| `ssl_endpoint`    | String |                             | An SSL end-point from which to download the certificate                                 |

## Examples

```ruby
java_certificate 'java_certificate_ssl_endpoint' do
  ssl_endpoint 'google.com:443'
  java_version '8'
end
```
