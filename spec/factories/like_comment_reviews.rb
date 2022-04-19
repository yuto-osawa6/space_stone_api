FactoryBot.define do
  factory :like_comment_review do
    association :comment_review
    association :user
    goodbad {1}
  end
end
