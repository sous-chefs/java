require 'chefspec'
require 'chefspec/policyfile'

require_relative '../libraries/certificate_helpers'
require_relative '../libraries/bin_cmd_helpers'
require_relative '../libraries/corretto_helpers'
require_relative '../libraries/openjdk_helpers'

module PolicyfileCookbookPath
  def initialize(options = {})
    if Array(options[:cookbook_path]).include?('spec/fixtures/cookbooks')
      options = options.merge(
        cookbook_path: Array(RSpec.configuration.cookbook_path) + [File.expand_path('fixtures/cookbooks', __dir__)]
      )
    end

    super(options)
  end
end

ChefSpec::SoloRunner.prepend(PolicyfileCookbookPath)

RSpec.configure do |config|
  config.file_cache_path = File.join(Dir.tmpdir, 'chefspec') if config.respond_to?(:file_cache_path)
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.platform = 'ubuntu'
  config.version = '18.04'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
