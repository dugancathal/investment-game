class Contract < ActiveRecord::Base
  VALID_CONTRACT_TYPES = %w(call future long put short)
  belongs_to :player
  belongs_to :ticker

  delegate :name, to: :ticker, prefix: true, allow_nil: true

  def self.from_file_for_player(file, player)
    config = YAML::load(file.read)
    config.each do |ticker, type|
      next unless VALID_CONTRACT_TYPES.include?(type.downcase)
      klass = type.classify.constantize
      ticker = Ticker.where(name: ticker).first_or_create!
      number_bought = purchasable_items_for_amount(ticker, klass.multiplier)
      klass.create!(ticker_id: ticker.id,
        player_id: player.id, value: number_bought,
        multiplier: klass.multiplier,
        commission: klass.commission_for(number_bought))
    end
  end

  def self.multiplier
    1
  end

  def self.purchasable_items_for_amount(ticker, multiplier, amount = 20000)
    current_price = Poll.retrieve(ticker).value
    (20000 / current_price).floor / multiplier.abs
  end

  def self.commission_for(number)
    -8.95
  end

  def current_profit(options = {})
    as_of = options.delete(:as_of) || Poll.order('created_at DESC').first
    current_holdings(as_of) - starting_holdings
  end

  def calculate_profit!
    player.profits.create! value: current_profit, ticker_id: self.ticker_id
  end

  def current_holdings(poll = polls.order('created_at DESC').first)
    poll.value * value * multiplier + commission
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

  def poll_on(date)
    polls.where(created_at: date.beginning_of_day..date.end_of_day).first
  end

  def profit_on(date)
    polls.where(created_at: date.beginning_of_day..date.end_of_day).first
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

  def self.inherited child
    child.instance_eval do
      def model_name
        Contract.model_name
      end
    end
    super
  end
end
