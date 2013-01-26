require 'date'

Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index do
    p Padrino.env
    if session[:show] || Padrino.env == :development
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

  get :'accounts.json', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    require 'set'

    # Nice little caching.
    if Padrino.env != :development
      etag "data/accounts-#{Account.maximum(:updated_at)}"
    end

    hash = {}
    dates = Set.new
    Account.all.each do |account|
      hash[account.name] ||= []
      if account.amount > 0
      hash[account.name].push({
        :date => account.created_at.to_date.strftime('%s'),
        :amount => account.amount,
      })
      dates.add account.created_at.to_date.strftime('%s')
      end
    end

    output = []
    hash.each_pair do |k,v|
      dates.each do |d|
        v.each do |val|
          if val[:date] == d
            break
          end
        end
        v.push({:date => d, :amount => 0})
      end

      output.push({ :key => k, :values => v })
    end

    if session[:show] || Padrino.env == :development
      content_type "application/json"
      return output.to_json
    else
      redirect :login
    end
  end

  get :'week_data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @weeks = Week.all

    # Nice little caching.
    if Padrino.env != :development
      etag "data/weeks-#{Week.maximum(:updated_at)}"
    end

    if session[:show] || Padrino.env == :development
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
      etag "data/months-#{Month.maximum(:updated_at)}"
    end

    if session[:show] || Padrino.env == :development
      content_type "text/csv"
      render :month_data, :layout => false
    else
      redirect :login
    end
  end
end
