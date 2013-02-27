namespace :investments do
  task :stalk => :environment do
    require 'httparty'
    Player.all.each do |player|
      puts player.email
      player.contracts.each do |contract|
        poll = Poll.retrieve!(contract.ticker)
        contract.calculate_profit!
        puts "#{poll.ticker.name} #{poll.value}"
      end
      player.calculate_total_profit!

      puts
    end
  end
end
