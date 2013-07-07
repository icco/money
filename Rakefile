require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'

PadrinoTasks.init

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

desc "Gets data from mint."
task :cron => :environment do
  mint = Mint.new(ENV['MINT_USERNAME'], ENV['MINT_PASSWORD'])

  # {:name=>"COMPENSATION PLAN", :amount=>0.0}
  mint.accounts.each do |account|
    a = Account.new
    a.amount = account[:amount]
    a.name = account[:name]
    a.save
  end
end

desc "Shrinks account data into months."
task :reduce => :environment do
  Account.all.each do |entry|
    w = Week.get entry.created_at.strftime('%G').to_i, entry.created_at.strftime('%V').to_i
    w.set entry.name, entry.amount
    w.save

    m = Month.get entry.created_at.year, entry.created_at.month
    m.set entry.name, entry.amount
    m.save
  end
end
