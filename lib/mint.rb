class Mint
  MINT_HOSTNAME =  "https://wwws.mint.com/"

  def initialize username, password

    if !username
      raise "Username not set!"
    end

    if !password
      raise "Password not set!"
    end

    # Setup
    # http://mechanize.rubyforge.org/Mechanize.html
    @agent = Mechanize.new
    @agent.log = Padrino.logger
    @agent.pluggable_parser.default = Mechanize::Download

    # Login
    page  = @agent.get(URI.join MINT_HOSTNAME, "/login.event")
    form = page.form_with(:id => "form-login")

    form.form-login-username = username
    form.form-login-password = password
    form.submit
  end

  def accounts
    trend_page = @agent.get(URI.join MINT_HOSTNAME, "/trend.event")
    form = trend_page.form_with(:action => "https://wwws.mint.com/trend.event")

    if form.nil?
      raise "Form has moved or user not logged in."
    end

    data = form['javascript-import-node'].chomp.sub('json = ', '').chomp(';')
    json = JSON.parse data

    accounts = []
    json['premiumaccountlist'].each do |account|
      if !account['isClosed']
        accounts.push({
          :name => account['accountName'],
          :amount => account['value']
        })
      end
    end

    return accounts
  end

  def transactions
    return @agent.get(URI.join MINT_HOSTNAME, "/transactionDownload.event").body
  end
end
