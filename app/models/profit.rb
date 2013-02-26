class Profit < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker
end
