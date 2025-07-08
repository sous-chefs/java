property :variant, String,
          equal_to: %w(openjdk semeru temurin),
          default: 'openjdk',
          description: 'Install flavour'
