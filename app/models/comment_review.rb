class CommentReview < ApplicationRecord
  belongs_to :review
  belongs_to :user

  has_many :like_comment_reviews,dependent: :destroy
  has_many :like_comment_reviews_users,through: :like_comment_reviews,source: :user
end
