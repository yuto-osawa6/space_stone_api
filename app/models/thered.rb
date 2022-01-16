class Thered < ApplicationRecord
  belongs_to :product
  belongs_to :user

  has_many :thered_quesitons, dependent: :destroy
  has_many :questions, through: :thered_quesitons, source: :question
  # accepts_nested_attributes_for :thered_quesions, allow_destroy: true

  # has_many :like_reviews, dependent: :destroy
  # has_many :like_reviews_users, through: :like_reviews, source: :user

  has_many :comment_threads, dependent: :destroy
  has_many :comment_threads_users, through: :comment_threads, source: :user
end
