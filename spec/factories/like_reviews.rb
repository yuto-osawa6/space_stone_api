FactoryBot.define do
  factory :like_review do
    association :review
    association :user
    goodbad {1}
  end
end
