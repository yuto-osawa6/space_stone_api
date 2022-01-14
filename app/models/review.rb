class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  # has_one_attached :content
  # has_many :like_reviews
  has_many :like_reviews, dependent: :destroy
  has_many :like_reviews_reviews, through: :thereds, source: :review
end
