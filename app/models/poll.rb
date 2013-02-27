class Poll < ActiveRecord::Base
  belongs_to :ticker

  YAHOO_FINANCE_ROOT = "http://finance.yahoo.com/"

  def self.retrieve!(ticker)
    response = HTTParty.get(YAHOO_FINANCE_ROOT + 'q/op', query: {s: ticker.name})
    doc = Nokogiri::XML(response.body)
    amount = doc.css('.time_rtq_ticker span').text()
    date_range = Date.today.beginning_of_day..Date.today.end_of_day
    where(ticker_id: ticker.id, value: amount, created_at: date_range).first_or_create!
  rescue SocketError
    retry
  end

  def amount
    "$%.2f" % value
  end

  def self.poll_dates
    (minimum('created_at').to_date..Date.today).to_a
  end
end
