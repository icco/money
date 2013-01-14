class Money
  def self.accounts
    # Setup
    # http://mechanize.rubyforge.org/Mechanize.html
    agent = Mechanize.new
    agent.log = Logger.new STDOUT
    agent.pluggable_parser.default = Mechanize::Download

    # Login
    page  = agent.get(URI.join hostname, "/login.event")
    form = page.form_with(:id => "form-login")

    form.username = username
    form.password = password
    form.submit

    # Get Transcations
    #transactions_csv = agent.get(URI.join hostname, "/transactionDownload.event").body

    trend_page = agent.get(URI.join hostname, "/trend.event")

    form = trend_page.form_with(:action => "https://wwws.mint.com/trend.event")
    data = form['javascript-import-node'].chomp.sub('json = ', '').delete(';')
    json = JSON.parse data

    json['premiumaccountlist'].each do |account|
      if !account['isClosed']
        puts "#{account['accountName']}: #{account['value']}"
      end
    end
  end
end
