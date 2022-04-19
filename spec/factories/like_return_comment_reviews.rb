FactoryBot.define do
  factory :like_return_comment_review do
    association :return_comment_review
    association :user
    goodbad {1}
  end
end
