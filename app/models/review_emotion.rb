class ReviewEmotion < ApplicationRecord
  belongs_to :review
  belongs_to :emotion
  belongs_to :product
  belongs_to :user
  belongs_to :episord,optional: true
end
