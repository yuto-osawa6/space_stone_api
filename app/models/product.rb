class Product < ApplicationRecord
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
  # has_many :products,through: :review_emotions, source: :product
  has_many :emotion_episords,through: :review_emotions, source: :episord
  has_many :emotion_users,through: :review_emotions , source: :user
  has_many :emotion_reviews,through: :review_emotions , source: :review

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

end
