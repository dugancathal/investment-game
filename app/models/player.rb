class Player < ActiveRecord::Base
  has_many :contracts
  has_many :tickers, through: :contracts
  has_many :profits
  attr_accessible :email
end
