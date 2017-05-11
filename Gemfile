source "https://rubygems.org"

ruby "2.4.0"

gem "activerecord", "~> 5.0", require: "active_record"
gem "coinbase"
gem "erubis"
gem "omniauth"
gem "omniauth-coinbase"
gem "rack-protection", require: "rack/protection"
gem "rack-ssl-enforcer"
gem "rake"
gem "secure_headers"
gem "sinatra", require: "sinatra/base"
gem "sinatra-activerecord", require: "sinatra/activerecord"
gem "textacular"
gem "thin"
gem "typhoeus"

group :test do
  gem "rack-test"
  gem "vcr"
end

# For dev
group :development do
  gem "rubocop"
  gem "shotgun"
  gem "travis"
end
