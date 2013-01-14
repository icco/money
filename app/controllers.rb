Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index, :cache => true do
    render :index
  end

  get :'data.csv', :cache => Padrino.env != :development do
    expires_in ONE_HOUR

    @months = Month.all

    if Padrino.env != :development
      etag "data/accounts-#{Month.maximum(:updated_at)}"
    end
    content_type "text/csv"
    render :data, :layout => false
  end
end
