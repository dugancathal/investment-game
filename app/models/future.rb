class Future < Contract
  def self.multiplier
    100
  end

  def calculate_profit!
    player.profits.create! value: profit_value, ticker_id: self.ticker_id
  end

  def polls
    Poll.where(ticker_id: self.ticker_id).order('created_at DESC')
  end

  private

  def profit_value
    (polls.first.value - polls.last.value) * value * multiplier + commission
  end
end
