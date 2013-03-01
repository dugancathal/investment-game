class Put < Contract
  def self.multiplier
    -100
  end

  def self.commission_for(number)
    -8.95 + (-0.75 * number)
  end

  def to_graph_json
    { 
      title: ticker.name, 
      contract_type: type.underscore,
      poll_dates: poll_dates,
      prices: ticker.related_stock.prices,
      strike_price: [ticker.prices.first] * ticker.prices.count,
      profits: profit_values,
      premium_prices: ticker.prices,
    }.to_json
  end
end
