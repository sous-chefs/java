require 'chefspec'
require 'chefspec/berkshelf'

require_relative '../libraries/adopt_openjdk_macos_helpers'
require_relative '../libraries/certificate_helpers'
require_relative '../libraries/corretto_helpers'
require_relative '../libraries/openjdk_helpers'

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
