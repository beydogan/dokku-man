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

ActiveRecord::Schema.define(version: 20160708100324) do

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
    t.integer  "host_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.hstore   "scale",      default: {}, null: false
    t.index ["host_id"], name: "index_apps_on_host_id", using: :btree
  end

  create_table "hosts", force: :cascade do |t|
    t.string   "name"
    t.string   "addr"
    t.text     "private_key"
    t.text     "public_key"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "username"
    t.string   "plugins",        default: [],              array: true
    t.datetime "last_synced_at"
  end

  create_table "plugin_instances", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "app_id"
    t.integer  "host_id"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_plugin_instances_on_app_id", using: :btree
    t.index ["host_id"], name: "index_plugin_instances_on_host_id", using: :btree
  end

  add_foreign_key "app_configs", "apps"
  add_foreign_key "apps", "hosts"
  add_foreign_key "plugin_instances", "apps"
  add_foreign_key "plugin_instances", "hosts"
end
