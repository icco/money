require 'date'

Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index, :cache => true do
    render :index
  end

  get :'week_data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @weeks = Week.all

    # Nice little caching.
    if Padrino.env != :development
      etag "data/accounts-#{Week.maximum(:updated_at)}"
    end

    content_type "text/csv"
    render :week_data, :layout => false
  end

  get :'month_data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @months = Month.all

    # Nice little caching.
    if Padrino.env != :development
      etag "data/accounts-#{Month.maximum(:updated_at)}"
    end

    content_type "text/csv"
    render :month_data, :layout => false
  end
end
