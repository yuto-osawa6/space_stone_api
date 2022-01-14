class LikeReturnCommentReview < ApplicationRecord
  belongs_to :return_comment_review
  belongs_to :user
  validates_uniqueness_of :return_comment_review_id, scope: :user_id
end
