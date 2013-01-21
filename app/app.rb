class Money < Padrino::Application
  register SassInitializer
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  use Honeybadger::Rack

  enable :sessions

  # TODO(icco): Fix.
  HIDE = true

  ##
  # Caching support
  #
  register Padrino::Cache
  enable :caching
  set :cache, Padrino::Cache::Store::Memory.new(100)
end
