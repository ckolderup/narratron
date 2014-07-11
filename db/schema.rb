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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140704210643) do

  create_table "days", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "story_id"
    t.datetime "date"
  end

  add_index "days", ["story_id"], name: "index_days_on_story_id"

  create_table "entries", force: true do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "text"
    t.boolean  "ending"
  end

  add_index "entries", ["user_id"], name: "index_entries_on_user_id"

  create_table "favorites", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "path_id"
  end

  add_index "favorites", ["path_id"], name: "index_favorites_on_path_id"
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

# Could not dump table "paths" because of following NoMethodError
#   undefined method `[]' for nil:NilClass

  create_table "stories", force: true do |t|
    t.string   "thanks"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
    t.string   "display_name"
  end

  create_table "votes", force: true do |t|
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "path_id"
  end

  add_index "votes", ["path_id"], name: "index_votes_on_path_id"

end
