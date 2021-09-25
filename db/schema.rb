# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_24_230942) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "email", limit: 255, null: false
    t.string "password_digest", limit: 60, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "name", limit: 12, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_id", null: false
    t.integer "level", default: 1, null: false
    t.integer "experience", default: 0, null: false
    t.datetime "active_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["account_id"], name: "index_characters_on_account_id"
    t.index ["active_at"], name: "index_characters_on_active_at"
    t.index ["name"], name: "index_characters_on_name", unique: true
    t.index ["room_id", "active_at"], name: "index_characters_on_room_id_and_active_at"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "x", null: false
    t.bigint "y", null: false
    t.bigint "z", null: false
    t.string "description", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["x", "y", "z"], name: "index_rooms_on_x_and_y_and_z", unique: true
  end

  add_foreign_key "characters", "accounts"
end
