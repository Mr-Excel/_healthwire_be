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

ActiveRecord::Schema[7.0].define(version: 2022_10_28_101509) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "level"
    t.string "lon"
    t.string "lat"
    t.string "alt_name"
    t.string "slug"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", force: :cascade do |t|
    t.integer "table_id"
    t.string "table_name"
    t.integer "method"
    t.string "payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_practices", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "default_items", force: :cascade do |t|
    t.string "item_name"
    t.integer "custom_id"
    t.integer "quantity"
    t.string "categories"
    t.string "param_type"
    t.float "param_value"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "custom_practice_id"
    t.string "remaining_name"
    t.string "second_name"
    t.index ["custom_practice_id"], name: "index_default_items_on_custom_practice_id"
  end

  create_table "formatted_items", force: :cascade do |t|
    t.string "item_name"
    t.integer "custom_id"
    t.integer "quantity"
    t.string "categories"
    t.string "param_type"
    t.float "param_value"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "custom_practice_id"
    t.string "remaining_name"
    t.string "second_name"
    t.index ["custom_practice_id"], name: "index_formatted_items_on_custom_practice_id"
  end

  create_table "login_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["user_id"], name: "index_login_histories_on_user_id"
  end

  create_table "mapped_items", force: :cascade do |t|
    t.integer "formatted_item_id"
    t.integer "default_item_id"
    t.integer "custom_practice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "practices", force: :cascade do |t|
    t.integer "doctor_id"
    t.string "doctor_name"
    t.string "doctor_slug"
    t.string "doctor_gender"
    t.integer "practice_id"
    t.string "practice_name"
    t.integer "doctor_fee"
    t.boolean "listed_status"
    t.float "doctor_experience"
    t.string "doctor_degree"
    t.string "practice_address"
    t.integer "practice_area_id"
    t.integer "practice_city_id"
    t.string "practice_city_name"
    t.string "doctor_specialities"
    t.string "doctor_timings"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.boolean "is_active"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "password_digest", default: "", null: false
    t.string "name", default: "", null: false
    t.integer "role", null: false
    t.string "gender", default: "", null: false
    t.string "email", default: "", null: false
    t.boolean "is_active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "default_items", "custom_practices"
  add_foreign_key "formatted_items", "custom_practices"
  add_foreign_key "login_histories", "users"
  add_foreign_key "users", "teams"
end
