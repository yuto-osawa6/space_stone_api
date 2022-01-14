class ReturnCommentReview < ApplicationRecord
  belongs_to :comment_review
  belongs_to :user
  validates_uniqueness_of :comment_review_id, scope: :user_id
end
