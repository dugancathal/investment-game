class Contract < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker
  attr_accessible :commission, :multiplier, :type, :value, :ticker_id, :player_id

  def calculate_profit!
    puts current_holdings - starting_holdings
    player.profits.create! value: current_holdings - starting_holdings, ticker_id: self.ticker_id
  end

  def current_holdings
    polls.first.value * value * multiplier + commission
  end

  def starting_holdings
    polls.last.value * value * multiplier + commission
  end

  def polls
    Poll.where(ticker_id: self.ticker_id).order('created_at DESC')
  end
end
