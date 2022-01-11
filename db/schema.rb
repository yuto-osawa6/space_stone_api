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

ActiveRecord::Schema.define(version: 2022_01_10_145200) do

  create_table "acsesses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
    t.index ["product_id"], name: "index_acsesses_on_product_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cast_products", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "cast_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cast_id"], name: "index_cast_products_on_cast_id"
    t.index ["product_id"], name: "index_cast_products_on_product_id"
  end

  create_table "casts", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comprehensives", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "like"
    t.string "score"
    t.string "acsess"
    t.integer "rank_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_comprehensives_on_product_id"
  end

  create_table "episords", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "title"
    t.text "arasuzi"
    t.integer "episord"
    t.integer "season"
    t.string "season_title"
    t.string "time"
    t.text "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_episords_on_product_id"
  end

  create_table "janl_products", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "janl_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["janl_id"], name: "index_janl_products_on_janl_id"
    t.index ["product_id"], name: "index_janl_products_on_product_id"
  end

  create_table "janls", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "likes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_likes_on_product_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "month_durings", charset: "utf8mb4", force: :cascade do |t|
    t.datetime "month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "newmessages", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "judge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "periods", charset: "utf8mb4", force: :cascade do |t|
    t.string "period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "image_url"
    t.text "description"
    t.text "list"
    t.string "end_day"
    t.boolean "finished", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "year"
    t.string "duration"
    t.boolean "new_content", default: false, null: false
    t.boolean "end", default: false, null: false
    t.boolean "pickup", default: false, null: false
    t.boolean "decision_news", default: false, null: false
    t.date "delivery_end"
    t.date "delivery_start"
    t.date "episord_start"
  end

  create_table "questions", charset: "utf8mb4", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reviews", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.text "title"
    t.string "discribe"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "scores", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_scores_on_product_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "style_products", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "style_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_style_products_on_product_id"
    t.index ["style_id"], name: "index_style_products_on_style_id"
  end

  create_table "styles", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "month_during_id", null: false
    t.bigint "product_id", null: false
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["month_during_id"], name: "index_tags_on_month_during_id"
    t.index ["product_id"], name: "index_tags_on_product_id"
  end

  create_table "thered_quesitons", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "thered_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_thered_quesitons_on_question_id"
    t.index ["thered_id"], name: "index_thered_quesitons_on_thered_id"
  end

  create_table "thereds", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.text "title"
    t.string "discribe"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_thereds_on_product_id"
    t.index ["user_id"], name: "index_thereds_on_user_id"
  end

  create_table "toptens", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "period_id", null: false
    t.bigint "product_id"
    t.string "title"
    t.string "list"
    t.string "category"
    t.integer "rank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "image_url"
    t.boolean "netflix_japan", default: false, null: false
    t.index ["period_id"], name: "index_toptens_on_period_id"
    t.index ["product_id"], name: "index_toptens_on_product_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "acsesses", "products"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cast_products", "casts"
  add_foreign_key "cast_products", "products"
  add_foreign_key "comprehensives", "products"
  add_foreign_key "episords", "products"
  add_foreign_key "janl_products", "janls"
  add_foreign_key "janl_products", "products"
  add_foreign_key "likes", "products"
  add_foreign_key "likes", "users"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "scores", "products"
  add_foreign_key "scores", "users"
  add_foreign_key "style_products", "products"
  add_foreign_key "style_products", "styles"
  add_foreign_key "tags", "month_durings"
  add_foreign_key "tags", "products"
  add_foreign_key "thered_quesitons", "questions"
  add_foreign_key "thered_quesitons", "thereds"
  add_foreign_key "thereds", "products"
  add_foreign_key "thereds", "users"
  add_foreign_key "toptens", "periods"
  add_foreign_key "toptens", "products"
end
