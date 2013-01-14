require File.expand_path('../config/boot.rb', __FILE__)
require 'padrino-core/cli/rake'

PadrinoTasks.init

desc "Run a local server."
task :local do
  Kernel.exec("shotgun -s thin -p 9393")
end

task :cron do
  mint = Mint.new(ENV['MINT_USERNAME'], ENV['MINT_PASSWORD'])

  mint.accounts.each do |account|
    p account
  end
end
