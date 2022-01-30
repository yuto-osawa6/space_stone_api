class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  # has_one_attached :content
  # has_many :like_reviews
  has_many :like_reviews, dependent: :destroy
  has_many :like_reviews_users, through: :like_reviews, source: :user

  has_many :comment_reviews, dependent: :destroy
  has_many :comment_reviews_users, through: :comment_reviews, source: :user

  # scope :goodbad_count do
  #   query = '(SELECT COUNT(likes.product_id) FROM likes where likes.product_id = products.id GROUP BY likes.product_id)'
  #   Arel.sql(query)
  # end
  has_many :acsess_articles
end
