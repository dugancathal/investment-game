#!/usr/bin/env ruby

require File.expand_path('../../config/environment', __FILE__)

config = YAML::load_file(File.expand_path('../../config/players.yml', __FILE__))
config.each do |email, data|
  data.each do |ticker, type|
    c = type.classify.constantize.where(ticker_id: Ticker.where(name: ticker).first_or_create.id, player_id: Player.where(email: email).first_or_create.id).first_or_create
  end
end
