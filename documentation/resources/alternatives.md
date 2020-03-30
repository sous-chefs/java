[back to resource list](https://github.com/sous-chefs/java#resources)

# java_alternatives

The `java_alternatives` resource uses `update-alternatives` command to set and unset command alternatives for various Java tools such as java, javac, etc.

## Actions

- `:set`: set alternatives for Java tools
- `:unset`: unset alternatives for Java tools

## Properties

| Name                 | Type          | Default | Description                                                                  |
| -------------------- | ------------- | ------- | ---------------------------------------------------------------------------- |
| `java_location`      | `String`      |         | Java installation location                                                   |
| `bin_cmds`           | `String`      |         | Array of Java tool names to set or unset alternatives on                     |
| `default`            | `true, false` | `true`  | Whether to set the Java tools as system default. Boolean, defaults to `true` |
| `priority`           | `Integer`     | `1061`  | Priority of the alternatives. Integer, defaults to `1061`                    |
| `reset_alternatives` | `true, false` | `true`  | Whether to reset alternatives before setting them                            |

- `java_location`: Java installation location.
- `bin_cmds`: .
- `default`: .
- `priority`: .

## Examples

```ruby
java_alternatives "set java alternatives" do
    java_location '/usr/local/java'
    bin_cmds ["java", "javac"]
end
```
