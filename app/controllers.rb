Money.controllers  do
  ONE_HOUR = 60*60

  layout :main

  get :index, :cache => true do
    render :index
  end

  get :'data.csv', :cache => true do
    expires_in ONE_HOUR

    @accounts = Account.all

    etag "data/accounts-#{Account.maximum(:created_at)}"
    content_type "text/csv"
    render :data, :layout => false
  end
end
