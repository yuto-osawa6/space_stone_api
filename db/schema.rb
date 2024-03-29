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

ActiveRecord::Schema.define(version: 2022_07_11_072938) do

  create_table "acsess_articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.integer "count", default: 0
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_acsess_articles_on_article_id"
  end

  create_table "acsess_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.integer "count", default: 0
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["review_id"], name: "index_acsess_reviews_on_review_id"
  end

  create_table "acsess_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "thered_id", null: false
    t.integer "count", default: 0
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thered_id"], name: "index_acsess_threads_on_thered_id"
  end

  create_table "acsesses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "date"
    t.index ["product_id"], name: "index_acsesses_on_product_id"
  end

  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "article_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "article_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_article_products_on_article_id"
    t.index ["product_id"], name: "index_article_products_on_product_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "content", size: :long
    t.string "title"
    t.boolean "weekormonth"
    t.datetime "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "casts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "character_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "products_id"
    t.bigint "characters_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["characters_id"], name: "index_character_products_on_characters_id"
    t.index ["products_id"], name: "index_character_products_on_products_id"
  end

  create_table "characters", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.bigint "cast_id"
    t.index ["cast_id"], name: "index_characters_on_cast_id"
    t.index ["product_id"], name: "index_characters_on_product_id"
  end

  create_table "chats", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.text "message", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_chats_on_product_id"
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "comment_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["review_id"], name: "index_comment_reviews_on_review_id"
    t.index ["user_id"], name: "index_comment_reviews_on_user_id"
  end

  create_table "comment_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "thered_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thered_id"], name: "index_comment_threads_on_thered_id"
    t.index ["user_id"], name: "index_comment_threads_on_user_id"
  end

  create_table "comprehensives", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "like"
    t.string "score"
    t.string "acsess"
    t.integer "rank_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_comprehensives_on_product_id"
  end

  create_table "data_infos", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "info"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "emotions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "emotion"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "episords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.text "title"
    t.text "arasuzi"
    t.integer "episord"
    t.integer "season"
    t.string "season_title"
    t.time "time"
    t.text "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "release_date"
    t.index ["product_id"], name: "index_episords_on_product_id"
  end

  create_table "error_manages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "controller"
    t.text "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hashtag_articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "hashtag_id", null: false
    t.bigint "article_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_id"], name: "index_hashtag_articles_on_article_id"
    t.index ["hashtag_id"], name: "index_hashtag_articles_on_hashtag_id"
  end

  create_table "hashtags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "images", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "impression_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "products_id", null: false
    t.bigint "impressions_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["impressions_id"], name: "index_impression_products_on_impressions_id"
    t.index ["products_id"], name: "index_impression_products_on_products_id"
  end

  create_table "impressions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "janl_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "janl_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["janl_id"], name: "index_janl_products_on_janl_id"
    t.index ["product_id"], name: "index_janl_products_on_product_id"
  end

  create_table "janls", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "kisetsu_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "kisetsu_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kisetsu_id"], name: "index_kisetsu_products_on_kisetsu_id"
    t.index ["product_id"], name: "index_kisetsu_products_on_product_id"
  end

  create_table "kisetsus", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "like_comment_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "comment_review_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_review_id"], name: "index_like_comment_reviews_on_comment_review_id"
    t.index ["user_id"], name: "index_like_comment_reviews_on_user_id"
  end

  create_table "like_comment_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "comment_thread_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_thread_id"], name: "index_like_comment_threads_on_comment_thread_id"
    t.index ["user_id"], name: "index_like_comment_threads_on_user_id"
  end

  create_table "like_return_comment_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "return_comment_review_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["return_comment_review_id"], name: "index_like_return_comment_reviews_on_return_comment_review_id"
    t.index ["user_id"], name: "index_like_return_comment_reviews_on_user_id"
  end

  create_table "like_return_comment_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "return_comment_thread_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["return_comment_thread_id"], name: "index_like_return_comment_threads_on_return_comment_thread_id"
    t.index ["user_id"], name: "index_like_return_comment_threads_on_user_id"
  end

  create_table "like_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["review_id"], name: "index_like_reviews_on_review_id"
    t.index ["user_id"], name: "index_like_reviews_on_user_id"
  end

  create_table "like_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "thered_id", null: false
    t.bigint "user_id", null: false
    t.integer "goodbad", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thered_id"], name: "index_like_threads_on_thered_id"
    t.index ["user_id"], name: "index_like_threads_on_user_id"
  end

  create_table "likes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_likes_on_product_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "month_durings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "newmessages", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "judge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "information"
    t.datetime "date"
  end

  create_table "occupations", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.bigint "staff_id"
    t.index ["product_id"], name: "index_occupations_on_product_id"
    t.index ["staff_id"], name: "index_occupations_on_staff_id"
  end

  create_table "periods", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "period"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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
    t.integer "season"
    t.time "time"
    t.date "year2"
    t.string "kisetsu"
    t.text "image_url2"
    t.text "image_url3"
    t.text "horizontal_image_url"
    t.text "horizontal_image_url2"
    t.text "horizontal_image_url3"
    t.text "overview"
    t.string "titleKa"
    t.string "titleEn"
    t.string "titleRo"
    t.integer "annitict"
    t.integer "shoboiTid"
    t.text "wiki"
    t.text "wikiEn"
    t.text "copyright"
    t.text "arasuzi_copyright"
  end

  create_table "questions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "question"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "return_comment_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "comment_review_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reply", default: false
    t.index ["comment_review_id"], name: "index_return_comment_reviews_on_comment_review_id"
    t.index ["user_id"], name: "index_return_comment_reviews_on_user_id"
  end

  create_table "return_comment_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "comment_thread_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "reply", default: false
    t.index ["comment_thread_id"], name: "index_return_comment_threads_on_comment_thread_id"
    t.index ["user_id"], name: "index_return_comment_threads_on_user_id"
  end

  create_table "return_return_comment_reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "return_comment_review_id", null: false
    t.bigint "return_return_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["return_comment_review_id"], name: "index_return_return_comment_reviews_on_return_comment_review_id"
    t.index ["return_return_id"], name: "index_return_return_comment_reviews_on_return_return_id"
  end

  create_table "return_return_comment_threads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "return_comment_thread_id", null: false
    t.bigint "return_return_thread_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["return_comment_thread_id"], name: "index_return_return_comment_threads_on_return_comment_thread_id"
    t.index ["return_return_thread_id"], name: "index_return_return_comment_threads_on_return_return_thread_id"
  end

  create_table "review_emotions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "review_id", null: false
    t.bigint "emotion_id", null: false
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.bigint "episord_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["emotion_id"], name: "index_review_emotions_on_emotion_id"
    t.index ["episord_id"], name: "index_review_emotions_on_episord_id"
    t.index ["product_id"], name: "index_review_emotions_on_product_id"
    t.index ["review_id"], name: "index_review_emotions_on_review_id"
    t.index ["user_id"], name: "index_review_emotions_on_user_id"
  end

  create_table "reviews", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.text "title"
    t.string "discribe"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "episord_id"
    t.integer "score"
    t.index ["episord_id"], name: "index_reviews_on_episord_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "scores", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "value", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "music"
    t.integer "character"
    t.integer "animation"
    t.integer "story"
    t.integer "performance"
    t.integer "all"
    t.index ["product_id"], name: "index_scores_on_product_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "seasons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "season"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "season_number"
  end

  create_table "staffs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "studio_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id", null: false
    t.bigint "studio_id", null: false
    t.index ["product_id"], name: "index_studio_products_on_product_id"
    t.index ["studio_id"], name: "index_studio_products_on_studio_id"
  end

  create_table "studios", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "company", null: false
    t.string "overview"
    t.text "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "style_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "style_id"
    t.bigint "product_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_style_products_on_product_id"
    t.index ["style_id"], name: "index_style_products_on_style_id"
  end

  create_table "styles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "month_during_id", null: false
    t.bigint "product_id", null: false
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "rank"
    t.integer "genre"
    t.string "month_title"
    t.index ["month_during_id"], name: "index_tags_on_month_during_id"
    t.index ["product_id"], name: "index_tags_on_product_id"
  end

  create_table "thered_quesitons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "thered_id", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_thered_quesitons_on_question_id"
    t.index ["thered_id"], name: "index_thered_quesitons_on_thered_id"
  end

  create_table "thereds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.text "title"
    t.string "discribe"
    t.text "content", size: :long
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "episord_id"
    t.index ["episord_id"], name: "index_thereds_on_episord_id"
    t.index ["product_id"], name: "index_thereds_on_product_id"
    t.index ["user_id"], name: "index_thereds_on_user_id"
  end

  create_table "tier_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "year_id"
    t.bigint "kisetsu_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kisetsu_id"], name: "index_tier_groups_on_kisetsu_id"
    t.index ["year_id"], name: "index_tier_groups_on_year_id"
  end

  create_table "tiers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "tier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tier_group_id", null: false
    t.bigint "user_tier_group_id", null: false
    t.integer "sort"
    t.index ["product_id"], name: "index_tiers_on_product_id"
    t.index ["tier_group_id"], name: "index_tiers_on_tier_group_id"
    t.index ["user_id"], name: "index_tiers_on_user_id"
    t.index ["user_tier_group_id"], name: "index_tiers_on_user_tier_group_id"
  end

  create_table "toptens", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
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

  create_table "trends", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_trends_on_product_id"
  end

  create_table "user_tier_groups", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "tier_group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tier_group_id"], name: "index_user_tier_groups_on_tier_group_id"
    t.index ["user_id"], name: "index_user_tier_groups_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "name"
    t.string "nickname"
    t.text "image", size: :long
    t.string "email"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "administrator_gold", default: false, null: false
    t.text "overview", size: :long
    t.text "background_image", size: :long
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "week_episords", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "episord_id", null: false
    t.bigint "week_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["episord_id"], name: "index_week_episords_on_episord_id"
    t.index ["week_id"], name: "index_week_episords_on_week_id"
  end

  create_table "weeklyrankings", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.datetime "weekly"
    t.integer "count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "week_id"
    t.index ["product_id"], name: "index_weeklyrankings_on_product_id"
    t.index ["week_id"], name: "index_weeklyrankings_on_week_id"
  end

  create_table "weeks", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "week"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "year_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "year_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_year_products_on_product_id"
    t.index ["year_id"], name: "index_year_products_on_year_id"
  end

  create_table "year_season_products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "year_id"
    t.bigint "kisetsu_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kisetsu_id"], name: "index_year_season_products_on_kisetsu_id"
    t.index ["product_id"], name: "index_year_season_products_on_product_id"
    t.index ["year_id"], name: "index_year_season_products_on_year_id"
  end

  create_table "years", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "acsess_articles", "articles"
  add_foreign_key "acsess_reviews", "reviews"
  add_foreign_key "acsess_threads", "thereds"
  add_foreign_key "acsesses", "products"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "users"
  add_foreign_key "chats", "products"
  add_foreign_key "chats", "users"
  add_foreign_key "comment_reviews", "reviews"
  add_foreign_key "comment_reviews", "users"
  add_foreign_key "comment_threads", "thereds"
  add_foreign_key "comment_threads", "users"
  add_foreign_key "comprehensives", "products"
  add_foreign_key "episords", "products"
  add_foreign_key "hashtag_articles", "articles"
  add_foreign_key "hashtag_articles", "hashtags"
  add_foreign_key "janl_products", "janls"
  add_foreign_key "janl_products", "products"
  add_foreign_key "like_comment_reviews", "comment_reviews"
  add_foreign_key "like_comment_reviews", "users"
  add_foreign_key "like_comment_threads", "comment_threads"
  add_foreign_key "like_comment_threads", "users"
  add_foreign_key "like_return_comment_reviews", "return_comment_reviews"
  add_foreign_key "like_return_comment_reviews", "users"
  add_foreign_key "like_return_comment_threads", "return_comment_threads"
  add_foreign_key "like_return_comment_threads", "users"
  add_foreign_key "like_reviews", "reviews"
  add_foreign_key "like_reviews", "users"
  add_foreign_key "like_threads", "thereds"
  add_foreign_key "like_threads", "users"
  add_foreign_key "likes", "products"
  add_foreign_key "likes", "users"
  add_foreign_key "return_comment_reviews", "comment_reviews"
  add_foreign_key "return_comment_reviews", "users"
  add_foreign_key "return_comment_threads", "comment_threads"
  add_foreign_key "return_comment_threads", "users"
  add_foreign_key "return_return_comment_reviews", "return_comment_reviews"
  add_foreign_key "return_return_comment_reviews", "return_comment_reviews", column: "return_return_id"
  add_foreign_key "return_return_comment_threads", "return_comment_threads"
  add_foreign_key "return_return_comment_threads", "return_comment_threads", column: "return_return_thread_id"
  add_foreign_key "review_emotions", "emotions"
  add_foreign_key "review_emotions", "episords"
  add_foreign_key "review_emotions", "products"
  add_foreign_key "review_emotions", "reviews"
  add_foreign_key "review_emotions", "users"
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
  add_foreign_key "trends", "products"
end
