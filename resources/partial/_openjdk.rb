property :variant, String,
          equal_to: %w(openjdk temurin),
          default: 'openjdk',
          description: 'Install flavour'
