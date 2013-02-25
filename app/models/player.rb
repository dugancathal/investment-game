class Player < ActiveRecord::Base
  has_many :contracts
  has_many :tickers, through: :contracts
  attr_accessible :email
end
