property :tap_url,
        String,
        description: 'The URL of the tap'

property :cask_options,
        String,
        description: 'Options to pass to the brew command during installation'

property :homebrew_path,
        String,
        description: 'The path to the homebrew binary'

property :owner,
        [String, Integer],
        description: 'The owner of the Homebrew installation'
