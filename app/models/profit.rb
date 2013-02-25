class Profit < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker
  attr_accessible :value
end
