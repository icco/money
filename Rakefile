require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'

PadrinoTasks.init

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

task :cron do
  mint = Mint.new(ENV['MINT_USERNAME'], ENV['MINT_PASSWORD'])

  # {:name=>"COMPENSATION PLAN", :amount=>0.0}
  mint.accounts.each do |account|
    a = Account.new
    a.amount = account[:amount]
    a.name = account[:name]
    a.save
  end
end
