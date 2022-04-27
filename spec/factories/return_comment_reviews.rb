FactoryBot.define do
  factory :return_comment_review do
    association :comment_review
    association :user
    comment {"comment"}
  end
end
