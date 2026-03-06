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

ActiveRecord::Schema[7.2].define(version: 2026_03_05_090315) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "milestones", force: :cascade do |t|
    t.bigint "relationship_id", null: false
    t.string "title", null: false
    t.date "occurred_on", null: false
    t.string "milestone_type", default: "custom", null: false
    t.text "description"
    t.text "my_perspective"
    t.text "partner_perspective"
    t.text "repair_notes"
    t.string "emotional_tags", default: [], array: true
    t.integer "emotional_intensity", default: 5
    t.string "photo_filename"
    t.boolean "awaiting_confirmation", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_type"], name: "index_milestones_on_milestone_type"
    t.index ["occurred_on"], name: "index_milestones_on_occurred_on"
    t.index ["relationship_id"], name: "index_milestones_on_relationship_id"
  end

  create_table "reflections", force: :cascade do |t|
    t.bigint "relationship_id", null: false
    t.string "prompt_type"
    t.text "content"
    t.boolean "private_note", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_reflections_on_created_at"
    t.index ["relationship_id"], name: "index_reflections_on_relationship_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.string "title", default: "Our Story", null: false
    t.string "mode", default: "solo", null: false
    t.string "status", default: "active", null: false
    t.integer "chapter_number", default: 1, null: false
    t.bigint "parent_chapter_id"
    t.date "began_on"
    t.date "ended_on"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_chapter_id"], name: "index_relationships_on_parent_chapter_id"
    t.index ["status"], name: "index_relationships_on_status"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "milestones", "relationships"
  add_foreign_key "reflections", "relationships"
end
