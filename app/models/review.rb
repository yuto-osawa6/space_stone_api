class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  # has_one_attached :content
  # has_many :like_reviews
  has_many :like_reviews, dependent: :destroy
  has_many :like_reviews_users, through: :like_reviews, source: :user

  has_many :comment_reviews, dependent: :destroy
  has_many :comment_reviews_users, through: :comment_reviews, source: :user
end
