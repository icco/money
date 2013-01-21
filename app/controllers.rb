require 'date'

Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index do
    if session[:show] || Padrino.env != :development
      render :index
    else
      redirect :login
    end
  end

  get :login do
    render :login
  end

  get '/auth/github/callback' do
    auth = request.env["omniauth.auth"]
    logger.push(" Github: #{auth.inspect}", :devel)

    session[:show] = auth["info"]["nickname"] == ENV['GITHUB_OWNER']

    if session[:show]
      redirect '/'
    else
      redirect :fail
    end
  end

  get :fail do
    session.clear
    render :fail, :layout => false
  end

  get :'week_data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @weeks = Week.all

    # Nice little caching.
    if Padrino.env != :development
      etag "data/accounts-#{Week.maximum(:updated_at)}"
    end

    if session[:show] || Padrino.env != :development
      content_type "text/csv"
      render :week_data, :layout => false
    else
      redirect :login
    end
  end

  get :'month_data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @months = Month.all

    # Nice little caching.
    if Padrino.env != :development
      etag "data/accounts-#{Month.maximum(:updated_at)}"
    end

    if session[:show] || Padrino.env != :development
      content_type "text/csv"
      render :month_data, :layout => false
    else
      redirect :login
    end
  end
end
