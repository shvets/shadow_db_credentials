$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:

  config.mock_with :mocha
  #config.mock_with :rspec

  # config.mock_with :flexmock
  # config.mock_with :rr

end