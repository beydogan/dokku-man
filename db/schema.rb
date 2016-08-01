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

ActiveRecord::Schema.define(version: 20160801191932) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "app_configs", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.integer  "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_app_configs_on_app_id", using: :btree
  end

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "server_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.hstore   "scale",      default: {}, null: false
    t.string   "git_url"
    t.index ["server_id"], name: "index_apps_on_server_id", using: :btree
  end

  create_table "plugin_instances", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "app_id"
    t.integer  "server_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_plugin_instances_on_app_id", using: :btree
    t.index ["server_id"], name: "index_plugin_instances_on_server_id", using: :btree
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.string   "addr"
    t.text     "private_key"
    t.text     "public_key"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "username"
    t.string   "plugins",        default: [],              array: true
    t.datetime "last_synced_at"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_servers_on_user_id", using: :btree
  end

  create_table "ssh_keys", force: :cascade do |t|
    t.string   "name"
    t.text     "key"
    t.string   "fingerprint"
    t.integer  "server_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["server_id"], name: "index_ssh_keys_on_server_id", using: :btree
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
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "app_configs", "apps"
  add_foreign_key "apps", "servers"
  add_foreign_key "plugin_instances", "apps"
  add_foreign_key "plugin_instances", "servers"
  add_foreign_key "servers", "users"
  add_foreign_key "ssh_keys", "servers"
end
