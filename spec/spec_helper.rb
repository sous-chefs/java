$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'libraries'))
require 'helpers'
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.file_cache_path = File.join(Dir.tmpdir, 'chefspec') if config.respond_to?(:file_cache_path)
  config.color = true
  config.tty = true
  config.formatter = :documentation
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.platform = 'ubuntu'
  config.version = '16.04'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
