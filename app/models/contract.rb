class Contract < ActiveRecord::Base
  belongs_to :player
  belongs_to :ticker

  def current_profit
    current_holdings - starting_holdings
  end

  def calculate_profit!
    player.profits.create! value: current_profit, ticker_id: self.ticker_id
  end

  def current_holdings
    polls.order('created_at DESC').first.value * value * multiplier + commission
  end

  def starting_holdings
    polls.order('created_at DESC').last.value * value * multiplier + commission
  end

  def polls
    Poll.where(ticker_id: self.ticker_id)
  end

  def poll_dates
    polls.order('created_at ASC').pluck(:created_at).map(&:to_date)
  end

  def profits
    Profit.where(ticker_id: self.ticker_id, player_id: player_id)
  end

  def profit_values
    profits.where(ticker_id: self.ticker_id).order('created_at ASC').pluck(:value)
  end

  def to_graph_json
    { 
      title: ticker.name, 
      contract_type: type.underscore,
      poll_dates: poll_dates,
      prices: ticker.prices,
      profits: profit_values,
    }.to_json
  end
end
