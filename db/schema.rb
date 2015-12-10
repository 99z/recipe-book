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

ActiveRecord::Schema.define(version: 20151210023921) do

  create_table "followerships", force: :cascade do |t|
    t.integer  "followed_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "followerships", ["followed_id", "follower_id"], name: "index_followerships_on_followed_id_and_follower_id", unique: true

  create_table "ingredients", force: :cascade do |t|
    t.string   "body",       default: "Add an ingredient...", null: false
    t.integer  "recipe_id",                                   null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "instructions", force: :cascade do |t|
    t.text     "body",       default: "Add your directions here...", null: false
    t.integer  "recipe_id",                                          null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "body",         default: "Add a note...", null: false
    t.string   "notable_type",                           null: false
    t.integer  "notable_id",                             null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "location"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "recipes", force: :cascade do |t|
    t.string   "title",       default: "Add a title...",                                                              null: false
    t.string   "author",      default: "Add an author...",                                                            null: false
    t.string   "photo_url",   default: "https://placeholdit.imgix.net/~text?txtsize=30&txt=320%C3%97320&w=320&h=320"
    t.integer  "user_id",                                                                                             null: false
    t.datetime "created_at",                                                                                          null: false
    t.datetime "updated_at",                                                                                          null: false
    t.string   "description", default: "Add a description..."
    t.string   "url"
  end

  create_table "shares", force: :cascade do |t|
    t.integer  "sharer_id",    null: false
    t.integer  "recipient_id", null: false
    t.integer  "recipe_id",    null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
