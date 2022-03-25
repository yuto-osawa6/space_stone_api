class Product < ApplicationRecord
  include Rails.application.routes.url_helpers
  # doneyet-1 下
  # has_many :cast_products
  # has_many :casts, through: :cast_products

  has_many :janl_products,dependent: :destroy
  has_many :janls, through: :janl_products

  has_many :style_products,dependent: :destroy
  has_many :styles, through: :style_products

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :scores, dependent: :destroy
  has_many :scores_users, through: :scores, source: :user

  has_many :acsesses, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :reviews_users, through: :reviews, source: :user

  has_many :thereds, dependent: :destroy
  has_many :thereds_users, through: :thereds, source: :user

  has_many :episords,dependent: :destroy

  has_many :toptens, dependent: :destroy
  has_many :toptens_periods, through: :thereds, source: :period

  has_many :tags, dependent: :destroy
  has_many :tags_month_durings, through: :thereds, source: :month_during

  # has_many :comprehensives,dependent: :destroy

  # 
  has_many :article_products, dependent: :destroy
  has_many :articles, through: :article_products, source: :article

  has_many :kisetsu_products,dependent: :destroy
  has_many :kisetsus, through: :kisetsu_products

  has_many :studio_products, dependent: :destroy
  has_many :studios, through: :studio_products

  has_many :characters, dependent: :destroy
  has_many :casts, through: :characters

  has_many :occupations, dependent: :destroy
  has_many :staffs, through: :occupations

  has_many :year_products, dependent: :destroy
  has_many :years, through: :year_products

  # 3tables
  has_many :year_season_products, dependent: :destroy
  has_many :year_season_years, through: :year_season_products, source: :year
  has_many :year_season_seasons,through: :year_season_products, source: :kisetsu

  # 5table
  has_many :review_emotions,dependent: :destroy
  has_many :emotions,through: :review_emotions, source: :emotion
  has_many :emotion_episords,through: :review_emotions, source: :episord
  has_many :emotion_users,through: :review_emotions , source: :user
  has_many :emotion_reviews,through: :review_emotions , source: :review

  # chats
  has_many :chats,dependent: :destroy
  has_many :users,through: :chats, source: :user

  has_many :weeklyrankings,dependent: :destroy
  has_many :weeks,through: :weeklyrankings,source: :week

  # tier
  
  has_many :tiers,dependent: :destroy
  has_many :users,through: :tiers,source: :user
  has_many :tier_groups,through: :tiers,source: :tier_group
  has_many :user_tier_groups,through: :tiers,source: :user_tier_group

  # image
  has_one_attached :bg_images
  has_one_attached :bg_images2

  def bgimage_url
    # 紐づいている画像のURLを取得する
    self.bg_images.attached? ? url_for(bg_images) : nil
  end
  def bgimage2_url
    # 紐づいている画像のURLを取得する
    self.bg_images2.attached? ? url_for(bg_images2) : nil
  end



  scope :years_year, -> { includes(year_season_products: :year) }
  scope :kisetsus_kisetsu, -> { includes(year_season_products: :kisetsu) }
  scope :year_season_scope, -> { years_year.kisetsus_kisetsu}


  ransacker :likes_count do
    query = '(SELECT COUNT(likes.product_id) FROM likes where likes.product_id = products.id GROUP BY likes.product_id)'
    Arel.sql(query)
  end

  ransacker :average_score do
    query = '(SELECT avg(scores.value) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end

  ransacker :acsess_count do
    query = '(SELECT sum(acsesses.count) FROM acsesses where acsesses.product_id = products.id GROUP BY acsesses.product_id)'
    Arel.sql(query)
  end

  ransacker :review_count do
    query = '(SELECT  COUNT(reviews.product_id) FROM reviews where reviews.product_id = products.id GROUP BY reviews.product_id)'
    Arel.sql(query)
  end

  ransacker :thread_count do
    query = '(SELECT  COUNT(thereds.product_id) FROM thereds where thereds.product_id = products.id GROUP BY thereds.product_id)'
    Arel.sql(query)
  end

  # 2.0
  ransacker :average_all_score do
    query = '(SELECT avg(scores.all) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end
  ransacker :average_music_score do
    query = '(SELECT avg(scores.music) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end
  ransacker :average_character_score do
    query = '(SELECT avg(scores.character) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end
  ransacker :average_performance_score do
    query = '(SELECT avg(scores.performance) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end
  ransacker :average_animation_score do
    query = '(SELECT avg(scores.animation) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end
  ransacker :average_story_score do
    query = '(SELECT avg(scores.story) FROM scores where scores.product_id = products.id GROUP BY scores.product_id)'
    Arel.sql(query)
  end

end
