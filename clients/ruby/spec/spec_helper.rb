require 'bundler/setup'
require 'rspec'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each {|f| require f}

require 'pandarus'

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.raise_errors_for_deprecations!

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end
end
