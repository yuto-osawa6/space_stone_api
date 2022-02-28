class Emotion < ApplicationRecord
  has_many :review_emotions,dependent: :destroy
  has_many :reviews,through: :review_emotions
end
