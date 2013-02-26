class Contract < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker

  def current_profit
    current_holdings - starting_holdings
  end

  def calculate_profit!
    puts current_holdings - starting_holdings
    player.profits.create! value: current_profit, ticker_id: self.ticker_id
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

  def profits
    Profit.where(ticker_id: self.ticker_id, player_id: player_id).order('created_at DESC')
  end
end
