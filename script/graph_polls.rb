#!/usr/bin/env ruby

require 'scruffy'
require File.expand_path('../../config/environment', __FILE__)

ActiveRecord::Base.establish_connection(
  database: 'game.db',
  pool: 5,
  adapter: 'sqlite3'
)

graph = Scruffy::Graph.new
graph.title = "GOOG"

graph.add :stacked do |stack|
  stack.add :line, 'Price/Premium', Poll.where(ticker: 'GOOG').pluck(:value).map(&:to_f)
end

graph.point_markers = Poll.select('distinct date').pluck(:date)
graph.render to: 'goog.png', width: 500, as: 'png'
