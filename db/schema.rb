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

ActiveRecord::Schema.define(version: 20160221233750) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "detections", force: :cascade do |t|
    t.string   "notification"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "duration_in_seconds"
    t.integer  "smart_product_id"
  end

  add_index "detections", ["smart_product_id"], name: "index_detections_on_smart_product_id", using: :btree

  create_table "mobile_devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "gcm_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "mobile_devices", ["user_id"], name: "index_mobile_devices_on_user_id", using: :btree

  create_table "smart_products", force: :cascade do |t|
    t.string   "serial_no"
    t.string   "type_of_smart_product"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "user_smart_products", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "smart_product_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "user_smart_products", ["smart_product_id"], name: "index_user_smart_products_on_smart_product_id", using: :btree
  add_index "user_smart_products", ["user_id"], name: "index_user_smart_products_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email_address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "detections", "smart_products"
  add_foreign_key "mobile_devices", "users"
  add_foreign_key "user_smart_products", "smart_products"
  add_foreign_key "user_smart_products", "users"
end
