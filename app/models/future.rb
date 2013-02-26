class Future < Contract
  def calculate_profit!
    player.profits.create! value: profit_value, ticker_id: self.ticker_id
  end

  private

  def profit_value
    (polls.first.value - polls.last.value) * value * multiplier + commission
  end
end
