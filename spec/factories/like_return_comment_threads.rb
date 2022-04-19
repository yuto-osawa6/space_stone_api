FactoryBot.define do
  factory :like_return_comment_thread do
    association :return_comment_thread
    association :user
    goodbad {1}
  end
end
