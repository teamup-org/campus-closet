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

ActiveRecord::Schema[7.1].define(version: 2024_04_02_225502) do
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

  create_table "chatrooms", force: :cascade do |t|
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_chatrooms_on_item_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conditions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "genders", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "color_id", null: false
    t.integer "type_id", null: false
    t.integer "gender_id", null: false
    t.text "description"
    t.integer "status_id", null: false
    t.integer "size_id", null: false
    t.integer "condition_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "brand"
    t.string "photo_link"
    t.string "image_url"
    t.integer "user_id"
    t.index ["color_id"], name: "index_items_on_color_id"
    t.index ["condition_id"], name: "index_items_on_condition_id"
    t.index ["gender_id"], name: "index_items_on_gender_id"
    t.index ["size_id"], name: "index_items_on_size_id"
    t.index ["status_id"], name: "index_items_on_status_id"
    t.index ["type_id"], name: "index_items_on_type_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chatroom_id", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pickups", force: :cascade do |t|
    t.integer "donor_id", null: false
    t.integer "receiver_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donor_id"], name: "index_pickups_on_donor_id"
    t.index ["item_id"], name: "index_pickups_on_item_id"
    t.index ["receiver_id"], name: "index_pickups_on_receiver_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "donor_id", null: false
    t.integer "receiver_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_slot_id", null: false
    t.index ["donor_id"], name: "index_requests_on_donor_id"
    t.index ["item_id"], name: "index_requests_on_item_id"
    t.index ["receiver_id"], name: "index_requests_on_receiver_id"
    t.index ["time_slot_id"], name: "index_requests_on_time_slot_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.integer "user_id", null: false
    t.integer "donor_id", null: false
    t.integer "pickup_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donor_id"], name: "index_reviews_on_donor_id"
    t.index ["pickup_id"], name: "index_reviews_on_pickup_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_id"
    t.index ["type_id"], name: "index_sizes_on_type_id"
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_slots", force: :cascade do |t|
    t.integer "donor_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donor_id"], name: "index_time_slots_on_donor_id"
  end

  create_table "types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first"
    t.string "last"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.boolean "student"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "donor"
    t.float "latitude"
    t.float "longitude"
    t.boolean "admin"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chatrooms", "items"
  add_foreign_key "items", "colors"
  add_foreign_key "items", "conditions"
  add_foreign_key "items", "genders"
  add_foreign_key "items", "sizes"
  add_foreign_key "items", "statuses"
  add_foreign_key "items", "types"
  add_foreign_key "items", "users"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "pickups", "items"
  add_foreign_key "pickups", "users", column: "donor_id"
  add_foreign_key "pickups", "users", column: "receiver_id"
  add_foreign_key "requests", "items"
  add_foreign_key "requests", "time_slots"
  add_foreign_key "requests", "users", column: "donor_id"
  add_foreign_key "requests", "users", column: "receiver_id"
  add_foreign_key "reviews", "pickups"
  add_foreign_key "reviews", "users"
  add_foreign_key "reviews", "users", column: "donor_id"
  add_foreign_key "sizes", "types"
  add_foreign_key "time_slots", "users", column: "donor_id"
end
