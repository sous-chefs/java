---
trigger: model_decision
---

# Chef Cookbook Tooling

## Ruby Environment

**NEVER run `bundle install`** - Chef Workstation provides all dependencies.

All Ruby executables are run via `chef exec`:

```fish
chef exec rspec
chef exec rubocop
chef exec cookstyle
```

## Available Binaries

Chef Workstation provides these tools in `/opt/chef-workstation/bin/`:

| Tool         | Purpose                                    |
|--------------|--------------------------------------------|
| `chef`       | Chef CLI                                   |
| `kitchen`    | Test Kitchen - integration testing         |
| `cookstyle`  | Chef-specific RuboCop rules                |
| `inspec`     | Infrastructure testing framework           |
| `knife`      | Chef server interaction                    |
| `berks`      | Berkshelf - cookbook dependency management |
| `foodcritic` | Deprecated linting (use cookstyle)         |

## Testing

### Unit Tests (ChefSpec)

```fish
chef exec rspec
chef exec rspec spec/libraries/
chef exec rspec --format documentation
```

### Integration Tests (Test Kitchen)

```fish
kitchen list              # List all test instances
kitchen create <instance> # Create VM/container
kitchen converge <instance> # Run Chef
kitchen verify <instance> # Run InSpec tests
kitchen test <instance>   # Full cycle: create, converge, verify, destroy
kitchen destroy <instance> # Cleanup
```

Short aliases: `kl`, `kc`, `kv`, `kt`, `kd`

### Linting

```fish
chef exec cookstyle       # Chef-specific RuboCop
chef exec cookstyle -a    # Auto-correct
chef exec rubocop         # Standard RuboCop
```

## Kitchen Configuration

- `kitchen.yml` - Main configuration
- `kitchen.dokken.yml` - Docker-based testing (fast)
- `kitchen.exec.yml` - Local execution
- `kitchen.global.yml` - Shared settings

Set kitchen config via environment:

```fish
set -x KITCHEN_YAML kitchen.dokken.yml
kitchen list
```
