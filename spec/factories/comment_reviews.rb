FactoryBot.define do
  factory :comment_review do
    association :review
    association :user
    comment {"comment"}
  end
end
