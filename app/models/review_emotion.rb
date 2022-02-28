class ReviewEmotion < ApplicationRecord
  belongs_to :review
  belongs_to :emotion
end
