class Profit < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker
  attr_accessible :value, :player_id, :ticker_id, :created_at, :updated_at
end
