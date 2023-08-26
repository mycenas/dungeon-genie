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

ActiveRecord::Schema[7.0].define(version: 2023_08_18_022940) do
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

  create_table "campaign_options", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "description"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaign_sessions", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_sessions_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "campaign_option_id", null: false
    t.index ["campaign_option_id"], name: "index_campaigns_on_campaign_option_id"
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "character_classes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "hit_die"
    t.string "primary_ability"
    t.string "spellcasting_ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "character_spells", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "spell_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_spells_on_character_id"
    t.index ["spell_id"], name: "index_character_spells_on_spell_id"
  end

  create_table "character_stats", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "stats_id", null: false
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_stats_on_character_id"
    t.index ["stats_id"], name: "index_character_stats_on_stats_id"
  end

  create_table "characters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.integer "level"
    t.bigint "race_id", null: false
    t.bigint "character_class_id", null: false
    t.integer "max_hp"
    t.integer "current_hp"
    t.string "armor_class"
    t.string "equipment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "gender"
    t.string "languages"
    t.string "image_path"
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_session_id", null: false
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_session_id"], name: "index_messages_on_campaign_session_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "ability_bonuses"
    t.string "traits"
    t.string "languages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.string "description"
    t.string "school"
    t.string "casting_time"
    t.string "range"
    t.string "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stats", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaign_sessions", "campaigns"
  add_foreign_key "campaigns", "campaign_options"
  add_foreign_key "campaigns", "users"
  add_foreign_key "character_spells", "characters"
  add_foreign_key "character_spells", "spells"
  add_foreign_key "character_stats", "characters"
  add_foreign_key "character_stats", "stats", column: "stats_id"
  add_foreign_key "characters", "character_classes"
  add_foreign_key "characters", "races"
  add_foreign_key "characters", "users"
  add_foreign_key "messages", "campaign_sessions"
  add_foreign_key "messages", "users"
end
