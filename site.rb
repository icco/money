require "rubygems"
require "bundler"
RACK_ENV = (ENV["RACK_ENV"] || :development).to_sym
Bundler.require(:default, RACK_ENV)

require "logger"

ActiveRecord::Base.extend(Textacular)

class Money < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  use Rack::Deflater
  use SecureHeaders::Middleware

  if RACK_ENV.eql? :production
    # Force HTTPS
    use Rack::SslEnforcer
  end

  layout :main
  configure do
    set :logging, true

    connections = {
      development: "postgres://localhost/money",
      test: "postgres://postgres@localhost/money_test",
      production: ENV["DATABASE_URL"],
    }

    url = URI(connections[RACK_ENV])
    options = {
      adapter: url.scheme,
      host: url.host,
      port: url.port,
      database: url.path[1..-1],
      username: url.user,
      password: url.password,
    }

    case url.scheme
    when "sqlite"
      options[:adapter] = "sqlite3"
      options[:database] = url.host + url.path
    when "postgres"
      options[:adapter] = "postgresql"
    end
    set :database, options

    use Rack::Session::Cookie, key: "rack.session",
                               path: "/",
                               expire_after: 86_400, # 1 day
                               secret: ENV["SESSION_SECRET"]
    use OmniAuth::Builder do
      provider :coinbase, ENV["COINBASE_CONSUMER_KEY"], ENV["COINBASE_CONSUMER_SECRET"]
    end

    # rubocop:disable
    SecureHeaders::Configuration.default do |config|
      # We just want the defaults.
      config.csp = {
        # "meta" values. these will shaped the header, but the values are not included in the header.
        preserve_schemes: true, # default: false. Schemes are removed from host sources to save bytes and discourage mixed content.

        # directive values: these values will directly translate into source directives
        default_src: %w(https: 'self'),
        base_uri: %w('self'),
        block_all_mixed_content: true, # see http://www.w3.org/TR/mixed-content/
        child_src: %w('self'), # if child-src isn't supported, the value for frame-src will be set.
        connect_src: %w(wss:),
        font_src: %w('self' data:),
        form_action: %w('self'),
        frame_ancestors: %w('none'),
        script_src: %w('self'),
        style_src: %w('unsafe-inline' unpkg.com),
      }
    end
    # rubocop:enable
  end

  before do
  end

  get "/health/?" do
    "ok"
  end

  get "/" do
    if session[:username]
      redirect "/home"
    else
      erb :login
    end
  end

  get "/auth/:name/callback" do
    auth = request.env["omniauth.auth"]
    session[:username] = auth.info.nickname

    redirect "/"
  end

  get "/logout" do
    session[:username] = nil
    session = nil

    redirect "/"
  end
end
