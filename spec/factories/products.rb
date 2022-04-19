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
  end

  factory :product_left, parent: :product do
    image_url {"image_url2"}
    after(:create) do |product|
      create(:style_product, product: product, style: Style.find(2))
      create(:style_product, product: product, style: Style.find(2))
    end
    after(:create) do |product|
      create(:janl_product,product: product, janl: create(:janl))
      create(:janl_product,product: product, janl: create(:janl))
    end
  end

  factory :product_alice, parent: :product do
    after(:create) do |product|
      create(:style_product, product: product, style: Style.find(2))
    end
    after(:create) do |product|
      create(:janl_product, product: product, janl: create(:janl))
    end
    after(:create) do |product|
      # create(:year_product, product: product, year: create(:year))
      create(:year_product, product: product, year: Year.exists?(year:"#{Time.current.year}-01-01")? Year.find_by(year:"#{Time.current.year}-01-01"): create(:year,year:"#{Time.current.year}-01-01"))
      # create(:year_season_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId),year:Year.exists?(year:"#{Time.current.year}-01-01")? Year.find_by(year:"#{Time.current.year}-01-01"): create(:year,year:"#{Time.current.year}-01-01"))

    end
    after(:create) do |product|
      create(:kisetsu_product, product: product, kisetsu: Kisetsu.find(1))
    end
    after(:create) do |product|
      create(:year_season_product, product: product, kisetsu: Kisetsu.find(1),year:product.years[0])
      create(:year_season_product, product: product, kisetsu: Kisetsu.find(6),year:product.years[0])
    end
    after(:create) do |product|
      create(:score, product: product,user: create(:user))
      create(:score, product: product,user: create(:user),value:40)
    end

    after(:create) do |product|
      create(:episord,product:product,release_date:Time.current.ago(1.hours))
      create(:episord, product: product,release_date:Time.current.ago(1.hours))
    end
    after(:create) do |product|
      create(:review, product: product,user: User.all[0],episord:Episord.all[0])
      create(:review, product: product,user: User.all[1],episord:Episord.all[1])
    end

    after(:create) do |product|
      create(:review_emotion, product: product,user: User.all[0],episord:Episord.all[0],review:Review.all[0],emotion:Emotion.find(1))
      create(:review_emotion, product: product,user: User.all[1],episord:Episord.all[0],review:Review.all[0],emotion:Emotion.find(2))
    end

    transient do
      current = Time.current
      case current.month
        when 1,2,3 then
          kisetsuId { 5 }
          kisetsuId2 { 4 }
          kisetsuId3 { 2 }
        when 4,5,6 then
          kisetsuId { 2 }
          kisetsuId2 { 5 }
          kisetsuId3 { 3 }
        when 7,8,9 then
          kisetsuId {3 }
          kisetsuId2 { 2 }
          kisetsuId3 { 4 }
        when 10,11,12 then
          kisetsuId { 4 }
          kisetsuId2 { 3 }
          kisetsuId3 { 5 }
      end        
    end

    factory :product_alice_like, parent: :product_alice do
      after(:create) do |product|
        create(:like,product:product,user:User.all[0])
      end
    end

    factory :product_alice_acsess, parent: :product_alice do
      after(:create) do |product|
        create(:acsess,product:product)
      end
    end

    factory :product_alice_thered, parent: :product_alice do
      after(:create) do |product|
        create(:thered,product:product,user: User.all[0])
      end
    end

    factory :product_alice_week, parent: :product_alice do
      after(:create) do |product|
        create(:weeklyranking,product:product,week:create(:week))
      end
    end
    

    factory :product_alice_tier, parent: :product_alice do
      after(:create) do |product|
        create(:tier_group,year:Year.first,kisetsu:Kisetsu.find(2))
        create(:tier,product:product,user:User.first,tier_group:TierGroup.first,user_tier_group:create(:user_tier_group,user:User.first,tier_group:TierGroup.first))
      end
    end

    # mainblock用--------------------------------------------------------

    factory :product_alice_new_netflix,parent: :product_alice do
      after(:create) do |product,eval|
        create(:kisetsu_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId))
      end
      after(:create) do |product,eval|
        create(:year_season_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId),year:Year.exists?(year:"#{Time.current.year}-01-01")? Year.find_by(year:"#{Time.current.year}-01-01"): create(:year,year:"#{Time.current.year}-01-01"))
      end
    end

    factory :product_alice_pickup,parent: :product_alice do
      after(:create) do |product,eval|
        create(:kisetsu_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId2))
        create(:kisetsu_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId3))
      end
      after(:create) do |product,eval|
        create(:year_season_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId2),year:Year.exists?(year:"#{Time.current.ago(3.month).year}-01-01")? Year.find_by(year:"#{Time.current.ago(3.month).year}-01-01"): create(:year,year:"#{Time.current.ago(3.month).year}-01-01"))
        create(:year_season_product, product: product, kisetsu: Kisetsu.find(eval.kisetsuId3),year:Year.exists?(year:"#{Time.current.ago(3.month).year}-01-01")? Year.find_by(year:"#{Time.current.since(3.month).year}-01-01"): create(:year,year:"#{Time.current.since(3.month).year}-01-01"))

      end
    end

    factory :product_alice_ranking,parent: :product_alice do
      after(:create) do |product,eval|
        create(:episord, product: product,release_date:Time.current.prev_week(:monday).since(7.hours))
        create(:weeklyranking,product:product,week:create(:week,week:Time.current.ago(6.hours).prev_week(:monday)),weekly:Time.current.ago(7.hours).prev_week(:monday))
      end
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