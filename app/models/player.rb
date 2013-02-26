class Player < ActiveRecord::Base
  has_many :contracts
  has_many :tickers, through: :contracts
  has_many :profits

  def calculate_total_profit!
    profits.create value: total_profit, ticker_id: Ticker.total_ticker.id
  end

  def total_profit
    contracts.map do |contract| 
      contract.profits.first.try(:value) || 0
    end.reduce(:+)
  end
end
