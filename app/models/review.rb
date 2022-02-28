class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  

  has_many :like_reviews, dependent: :destroy
  has_many :like_reviews_users, through: :like_reviews, source: :user

  has_many :comment_reviews, dependent: :destroy
  has_many :comment_reviews_users, through: :comment_reviews, source: :user

  # scope :goodbad_count do
  #   query = '(SELECT COUNT(likes.product_id) FROM likes where likes.product_id = products.id GROUP BY likes.product_id)'
  #   Arel.sql(query)
  # end
  has_many :acsess_reviews, dependent: :destroy
  belongs_to :episord,optional:true

  has_many :review_emotions,dependent: :destroy
  has_many :emotions,through: :review_emotions

  # validation
  validates :episord_id, uniqueness: { scope: [:product_id, :user_id] },allow_nil: true
end
