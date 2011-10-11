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

ActiveRecord::Schema.define(:version => 20111007172913) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_people", :id => false, :force => true do |t|
    t.integer "group_id",  :null => false
    t.integer "person_id", :null => false
  end

  add_index "groups_people", ["person_id", "group_id"], :name => "people_groups_idx"

  create_table "people", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.boolean  "is_user",                                :default => false
    t.string   "login",                   :limit => 40
    t.string   "email",                   :limit => 100
    t.datetime "usage_terms_accepted_at"
    t.boolean  "is_author",                              :default => false
    t.string   "pseudonym"
    t.date     "birthdate"
    t.date     "deathdate"
    t.string   "nationality"
    t.text     "wiki_links"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
