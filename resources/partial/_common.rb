property :version, String,
          name_property: true,
          description: 'Java version to install'

property :skip_alternatives, [true, false],
          default: false,
          description: 'Skip alternatives installation'
