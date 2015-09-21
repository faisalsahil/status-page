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

ActiveRecord::Schema.define(:version => 20141016105656) do

  create_table "clients", :force => true do |t|
    t.string   "phone"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "components", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
    t.integer  "status_id"
    t.string   "random_key"
  end

  create_table "customizepages", :force => true do |t|
    t.string   "theme"
    t.string   "favicon"
    t.string   "coverimage"
    t.string   "background_color"
    t.string   "font_color"
    t.string   "link_color"
    t.string   "yellows"
    t.string   "reds"
    t.string   "greens"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.integer  "user_id"
    t.text     "customcss"
    t.text     "customheader"
    t.text     "customfooter"
    t.string   "logoname"
    t.text     "abouttext"
    t.boolean  "coverimageshow"
    t.string   "systemcomponentstitle"
    t.string   "abouttexttitle"
    t.string   "logo"
  end

  create_table "datasources", :force => true do |t|
    t.string   "source_name"
    t.string   "ds_email"
    t.string   "ds_pass"
    t.string   "ds_appkey"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "dimensions_validators", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "incidents", :force => true do |t|
    t.string   "name"
    t.string   "status"
    t.string   "message"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "user_id"
    t.integer  "component_id"
    t.integer  "state_id"
  end

  create_table "maintenances", :force => true do |t|
    t.string   "description"
    t.integer  "component_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "title"
    t.datetime "start_at"
    t.datetime "end_at"
  end

  create_table "metrics", :force => true do |t|
    t.string   "userdef_name"
    t.string   "name"
    t.string   "hostname"
    t.string   "status"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "datasource_id"
    t.boolean  "displayit"
  end

  create_table "payments", :force => true do |t|
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "card_number"
    t.string   "card_code"
    t.string   "card_exp_date"
    t.integer  "user_id"
    t.string   "token"
    t.string   "subscription_id"
    t.string   "customer_id"
    t.integer  "plan_id"
  end

  create_table "plans", :force => true do |t|
    t.integer  "available_notifications"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "plan_type"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "default_value"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "default_value"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                      :default => "",       :null => false
    t.string   "encrypted_password",         :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              :default => 0,        :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "username"
    t.string   "user_type",                  :default => "null"
    t.string   "time_zone",                  :default => "London"
    t.string   "random_key"
    t.string   "customurl"
    t.integer  "history",                    :default => 30
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "uid_twitter"
    t.string   "name_twitter"
    t.string   "emailsubjectformat"
    t.text     "emailbodyformat"
    t.string   "tweetformat"
    t.string   "emailsubjectincidentformat"
    t.text     "emailbodyincidentformat"
    t.string   "tweetincidentformat"
    t.integer  "sent_notifications",         :default => 0
    t.string   "plan",                       :default => "Free"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
