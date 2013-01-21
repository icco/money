class Money < Padrino::Application
  register SassInitializer
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  if PADRINO_ENV != "development"
    use Honeybadger::Rack
  end

  HIDE = false

  enable :sessions

  ##
  # Caching support
  #
  register Padrino::Cache
  enable :caching
  set :cache, Padrino::Cache::Store::Memory.new(100)

  OmniAuth.config.logger = logger
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: "user"
  end
end
