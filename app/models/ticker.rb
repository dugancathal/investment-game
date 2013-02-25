class Ticker < ActiveRecord::Base
  attr_accessible :name
  has_many :polls

  def prices
    polls.map(&:value)
  end

  def poll_dates
    polls.map {|poll| poll.created_at.to_date}
  end

  def profits_for(player)
    []
  end
  
  def to_graph_json(player)
    { 
      "title" => name, 
      "poll_dates" => poll_dates,
      "prices" => prices,
      "profits" =>  profits_for(player)
    }.to_json
  end
end
