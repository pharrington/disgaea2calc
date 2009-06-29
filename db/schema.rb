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

  create_table "disgaea2_items", :force => true do |t|
    t.string  "name",     :limit => 25
    t.integer "rank",     :limit => 1
    t.integer "stat_hp"
    t.integer "stat_sp"
    t.integer "stat_atk"
    t.integer "stat_def"
    t.integer "stat_int"
    t.integer "stat_res"
    t.integer "stat_hit"
    t.integer "stat_spd"
    t.integer "type",     :limit => 1
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "users", :force => true do |t|
    t.string "login_name"
    t.string "password"
    t.string "realname_first"
    t.string "realname_last"
  end

end
