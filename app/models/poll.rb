class Poll < ActiveRecord::Base
  belongs_to :ticker
  attr_accessible :value, :ticker_id

  YAHOO_FINANCE_ROOT = "http://finance.yahoo.com/"

  def self.retrieve!(ticker)
    response = HTTParty.get(YAHOO_FINANCE_ROOT + 'q/op', query: {s: ticker.name})
    doc = Nokogiri::XML(response.body)
    amount = doc.css('.time_rtq_ticker span').text()
    date_range = Date.today.beginning_of_day..Date.today.end_of_day
    where(ticker_id: ticker.id, value: amount, created_at: date_range).first_or_create!
  end

  def amount
    "$" + value.to_s
  end
end
