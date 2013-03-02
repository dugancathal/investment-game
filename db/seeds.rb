# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'
rows = CSV.parse(File.read(Rails.root.join('config', 'player-seeds.csv')), headers: true, header_converters: [:downcase, :symbol])
rows.each do |row|
  player = Player.where(email: row[:email]).first_or_create!
  ticker = Ticker.where(name: row[:ticker]).first_or_create!
  contract = row[:type].classify.constantize.create! player_id: player.id, 
    ticker_id: ticker.id, value: row[:value],
    multiplier: row[:multiplier],
    commission: row[:commission]
  player.profits.create ticker_id: ticker.id, value: 0, created_at: row[:date], updated_at: row[:date]
end

rows = CSV.parse(File.read(Rails.root.join('config', 'poll-seeds.csv')), headers: true, header_converters: [:downcase, :symbol])
rows.each do |row|
  ticker = Ticker.where(name: row[:ticker]).first_or_create!
  Poll.create ticker_id: ticker.id, value: row[:value], created_at: row[:date], updated_at: row[:date]
end
