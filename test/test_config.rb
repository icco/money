RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path('../../config/boot', __FILE__)

class MiniTest::Unit::TestCase
  include RR::Adapters::MiniTest
  include Rack::Test::Methods

  def app
    Padrino.application
  end
end
