require 'date'

Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index do
    if isLoggedIn?
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

    if isLoggedIn?
      redirect '/'
    else
      redirect :fail
    end
  end

  get :fail do
    session.clear
    render :fail, :layout => false
  end

  get :'accounts.json', :cache => isProd? do
    expires_in ONE_HOUR

    require 'set'

    # Nice little caching.
    if isProd?
      etag "data/accounts-#{Account.maximum(:updated_at)}"
    end

    # create a hash grouped by account name
    hash = {}
    dates = Set.new
    Account.order("created_at").all.each do |account|
      hash[account.name] ||= []
      if account.amount > 0
        hash[account.name].push({
          :date => account.created_at.to_date.strftime('%Q'),
          :amount => account.amount,
        })
      end
    end

    # put zeros for days we don't have data
    output = []
    hash.each_pair do |k,v|
      output.push({ :key => k, :values => v })
    end

    if isLoggedIn?
      content_type "application/json"
      return [output[0]].to_json
    else
      redirect :login
    end
  end

  get :'week_data.csv', :cache => isProd? do
    expires_in ONE_HOUR

    @weeks = Week.all

    # Nice little caching.
    if isProd?
      etag "data/weeks-#{Week.maximum(:updated_at)}"
    end

    if isLoggedIn?
      content_type "text/csv"
      render :week_data, :layout => false
    else
      redirect :login
    end
  end

  get :'month_data.csv', :cache => isProd? do
    expires_in ONE_HOUR

    @months = Month.all

    # Nice little caching.
    if isProd?
      etag "data/months-#{Month.maximum(:updated_at)}"
    end

    if isLoggedIn?
      content_type "text/csv"
      render :month_data, :layout => false
    else
      redirect :login
    end
  end
end
