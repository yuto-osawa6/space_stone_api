FactoryBot.define do
  factory :product,class: Product do
    sequence(:title) { |n| "TEST_PRODUCT#{n}"}
    image_url {"image_url"}
    description {"description"}
    list {"list"}
    end_day {"end_day"}
    finished {1}
    created_at {"20220410"}
    updated_at {"20220410"}
    year {"2022"}
    duration {""}
    new_content {false}
    # end
    pickup {false}
    decision_news {false}
    delivery_end {""}
    delivery_start {""}
    season {""}
    time {""}
    year2 {""}
    kisetsu {""}
    image_url2 {""}
    image_url3 {""}
    horizontal_image_url {""}
    horizontal_image_url2 {""}
    horizontal_image_url3 {""}
    overview {""}
    titleKa {""}
    titleEn {""}
    titleRo {""}
    annitict {""}
    shoboiTid {""}
    wiki {""}
    wikiEn {""}
    copyright {""}

    # factory :alice do
    #   name 'Alice'
    #   admin true
    # end

  end

  factory :product_left, parent: :product do
    image_url {"image_url2"}
    after(:create) do |product|
      create(:style_product, product: product, style: create(:style))
      create(:style_product, product: product, style: create(:style))
    end
    after(:create) do |product|
      create(:janl_product,product: product, janl: create(:janl))
      create(:janl_product,product: product, janl: create(:janl))
    end
  end

  factory :product_alice, parent: :product do
    after(:create) do |product|
      create(:style_product, product: product, style: create(:style))
    end
    after(:create) do |product|
      create(:janl_product, product: product, janl: create(:janl))
    end

    after(:create) do |product|
      create(:year_product, product: product, year: create(:year))
    end

    after(:create) do |product|
      create(:kisetsu_product, product: product, kisetsu: Kisetsu.find(1))
    end

    after(:create) do |product|
      create(:year_season_product, product: product, kisetsu: Kisetsu.find(1),year:product.years[0])
      create(:year_season_product, product: product, kisetsu: Kisetsu.find(2),year:product.years[0])
    end



  end

end



# t.string "title"
# t.text "image_url"
# t.text "description"
# t.text "list"
# t.string "end_day"
# t.boolean "finished", default: false, null: false
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.string "year"
# t.string "duration"
# t.boolean "new_content", default: false, null: false
# t.boolean "end", default: false, null: false
# t.boolean "pickup", default: false, null: false
# t.boolean "decision_news", default: false, null: false
# t.date "delivery_end"
# t.date "delivery_start"
# t.date "episord_start"
# t.integer "season"
# t.time "time"
# t.date "year2"
# t.string "kisetsu"
# t.text "image_url2"
# t.text "image_url3"
# t.text "horizontal_image_url"
# t.text "horizontal_image_url2"
# t.text "horizontal_image_url3"
# t.text "overview"
# t.string "titleKa"
# t.string "titleEn"
# t.string "titleRo"
# t.integer "annitict"
# t.integer "shoboiTid"
# t.string "wiki"
# t.string "wikiEn"
# t.string "copyright"