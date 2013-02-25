class Contract < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker
  attr_accessible :commission, :multiplier, :type, :value, :ticker_id, :player_id
end
