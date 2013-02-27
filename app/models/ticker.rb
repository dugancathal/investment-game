class Ticker < ActiveRecord::Base
  has_many :polls
  has_many :contracts
  has_many :players, through: :contracts
  has_many :profits

  def self.total_ticker
    Ticker.where(name: 'TOTAL').first_or_create
  end

  def stock_name
    name[/^\D+/]
  end

  def related_stock
    Ticker.where(name: stock_name).first
  end

  def last_poll
    polls.order('created_at desc').first || Poll.new
  end

  def prices
    polls.pluck(:value)
  end

  def poll_dates
    polls.map {|poll| poll.created_at.to_date}
  end

  def profits_for(player)
    if player
      player.profits.where(ticker_id: self.id).pluck(:value)
    end
  end

  def contract_for(player)
    Contract.where(player_id: player.id, ticker_id: self.id).first
  end
  
  def to_graph_json(player)
    { 
      title: name, 
      contract_type: contract_for(player).type.underscore,
      poll_dates: poll_dates,
      prices: prices,
      profits: profits_for(player)
    }.to_json
  end
end
