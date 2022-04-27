FactoryBot.define do
  factory :review_emotion do
    association :episord
    association :product
    association :user
    association :review
    association :emotion
  end
end
