# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "categories", :force => true do |t|
    t.string "identifier"
    t.string "intro",      :limit => 1000
  end

  create_table "collections", :force => true do |t|
    t.string "identifier", :limit => 100
  end

  create_table "collections_things", :id => false, :force => true do |t|
    t.integer "collection_id"
    t.integer "thing_id"
  end

  create_table "countries", :force => true do |t|
    t.string "name", :limit => 500
  end

  create_table "countries_units", :id => false, :force => true do |t|
    t.integer "country_id"
    t.integer "unit_id"
  end

  create_table "exchange_rates", :force => true do |t|
    t.integer "first_unit_id"
    t.integer "second_unit_id"
    t.string  "rate",           :limit => 50
  end

  create_table "things", :force => true do |t|
    t.string  "identifier", :limit => 1000
    t.text    "body"
    t.integer "unit_id"
    t.float   "value"
    t.text    "citation"
    t.integer "verified",                   :default => 1
    t.integer "pronoun",                    :default => 0
  end

  create_table "units", :force => true do |t|
    t.string  "name",            :limit => 500
    t.integer "category_id"
    t.integer "base_unit_id"
    t.float   "base_unit_ratio"
    t.string  "symbol",          :limit => 10
    t.integer "symbol_before"
  end

end
