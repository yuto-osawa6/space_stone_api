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

ActiveRecord::Schema.define(version: 2021_11_18_082658) do

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

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.string "title"
    t.text "image_url"
    t.text "description"
    t.text "list"
    t.string "end_day"
    t.boolean "finished", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  add_foreign_key "cast_products", "casts"
  add_foreign_key "cast_products", "products"
  add_foreign_key "janl_products", "janls"
  add_foreign_key "janl_products", "products"
  add_foreign_key "style_products", "products"
  add_foreign_key "style_products", "styles"
end
