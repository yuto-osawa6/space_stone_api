class LikeReview < ApplicationRecord
  belongs_to :review
  belongs_to :user
  validates_uniqueness_of :review_id, scope: :user_id
end
