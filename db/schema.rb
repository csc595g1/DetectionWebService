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

ActiveRecord::Schema.define(version: 20160217221041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "detections", force: :cascade do |t|
    t.string   "notification"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "duration_in_seconds"
    t.integer  "device_id"
  end

  add_index "detections", ["device_id"], name: "index_detections_on_device_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "serial_no"
    t.string   "type_of_device"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "detections", "devices"
  add_foreign_key "devices", "users"
end
