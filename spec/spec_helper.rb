$: << File.expand_path(File.dirname(__FILE__) + '/../lib')

RSpec.configure do |config|
  config.mock_with :mocha
  #config.mock_with :rspec
end