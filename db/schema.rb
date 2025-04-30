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

ActiveRecord::Schema[8.0].define(version: 2025_04_30_051725) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "building_clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "building_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_building_clients_on_building_id"
    t.index ["user_id"], name: "index_building_clients_on_user_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.string "rut"
    t.string "address_reference"
    t.integer "floors"
    t.bigint "property_manager_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "underground_floors", default: 0, null: false
    t.index ["property_manager_id"], name: "index_buildings_on_property_manager_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "building_id", null: false
    t.decimal "price"
    t.string "currency"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["building_id"], name: "index_contracts_on_building_id"
  end

  create_table "daily_tasks", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.date "date"
    t.string "name"
    t.text "description"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "completed_by_id"
    t.integer "status"
    t.index ["completed_by_id"], name: "index_daily_tasks_on_completed_by_id"
    t.index ["service_id"], name: "index_daily_tasks_on_service_id"
  end

  create_table "property_managers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_participants", force: :cascade do |t|
    t.bigint "service_id", null: false
    t.bigint "user_id", null: false
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_id"], name: "index_service_participants_on_service_id"
    t.index ["user_id"], name: "index_service_participants_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "status"
    t.bigint "building_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_date"
    t.datetime "end_date"
    t.index ["building_id"], name: "index_services_on_building_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "second_last_name"
    t.string "rut"
    t.date "birthdate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "building_clients", "buildings"
  add_foreign_key "building_clients", "users"
  add_foreign_key "buildings", "property_managers"
  add_foreign_key "contracts", "buildings"
  add_foreign_key "daily_tasks", "services"
  add_foreign_key "daily_tasks", "users", column: "completed_by_id"
  add_foreign_key "service_participants", "services"
  add_foreign_key "service_participants", "users"
  add_foreign_key "services", "buildings"
end
