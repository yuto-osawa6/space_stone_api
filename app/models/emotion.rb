class Emotion < ApplicationRecord
  has_many :review_emotions,dependent: :destroy
  # has_many :emotions,through: :review_emotions, source: :emotion
  has_many :products,through: :review_emotions, source: :product
  has_many :emotion_episords,through: :review_emotions, source: :episord
  has_many :emotion_users,through: :review_emotions , source: :user
  has_many :emotion_reviews,through: :review_emotions , source: :review
end
