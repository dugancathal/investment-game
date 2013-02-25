# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130225045014) do

  create_table "contracts", :force => true do |t|
    t.integer  "player_id"
    t.integer  "ticker_id"
    t.float    "value",      :default => 0.0
    t.integer  "multiplier", :default => 0
    t.float    "commission", :default => -8.95
    t.string   "type"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "contracts", ["player_id"], :name => "index_contracts_on_player_id"
  add_index "contracts", ["ticker_id"], :name => "index_contracts_on_ticker_id"

  create_table "players", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "polls", :force => true do |t|
    t.integer  "ticker_id"
    t.float    "value",      :default => 0.0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "polls", ["ticker_id"], :name => "index_polls_on_ticker_id"

  create_table "profits", :force => true do |t|
    t.float    "value",      :default => 0.0
    t.integer  "player_id"
    t.integer  "ticker_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "profits", ["player_id"], :name => "index_profits_on_player_id"
  add_index "profits", ["ticker_id"], :name => "index_profits_on_ticker_id"

  create_table "tickers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
