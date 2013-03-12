class Player < ActiveRecord::Base
  has_many :contracts
  has_many :longs
  has_many :shorts
  has_many :calls
  has_many :puts
  has_many :futures
  has_many :tickers, through: :contracts
  has_many :profits

  attr_accessor :config_file

  def username
    email.split('@').first
  end

  def calculate_total_profit!
    profits.create value: total_profit, ticker_id: Ticker.total_ticker.id
  end

  def total_profit
    contracts.map do |contract| 
      contract.profits.order('created_at DESC').first.try(:value) || 0
    end.reduce(:+)
  end

  def profit_prices
    profits.order('created_at ASC').where(ticker_id: Ticker.total_ticker).pluck(:value)
  end

  %w(long short call put future).each do |stock_type|
    define_method "#{stock_type}" do
      send(stock_type.pluralize).first
    end
  end

  def pl_for_date(date)
    profits.where(created_at: date.beginning_of_day..date.end_of_day, ticker_id: Ticker.total_ticker.id).first
  end

  def to_graph_json
    { 
      "title" => 'Total P/L', 
      "poll_dates" => Poll.poll_dates,
      "profits" => profit_prices,
    }.to_json
  end
end
