FactoryBot.define do
  factory :like_comment_thread do
    association :comment_thread
    association :user
    goodbad {1}
  end
end
