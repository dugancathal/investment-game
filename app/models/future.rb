class Future < Contract
  def self.multiplier
    100
  end

  def calculate_profit!
    player.profits.create! value: profit_value, ticker_id: self.ticker_id
  end

  private

  def profit_value
    profitable_polls = polls.order('created_at DESC')
    (profitable_polls.first.value - profitable_polls.last.value) * value * multiplier + commission
  end
end
