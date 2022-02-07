property :alternatives_priority, Integer,
        default: 1,
        description: 'Alternatives priority to set for this Java'

property :reset_alternatives, [true, false],
        default: true,
        description: 'Whether to reset alternatives before setting'

property :default, [true, false],
        default: true,
        description: ' Whether to set this as the default Java'
