FactoryBot.define do
  factory :return_comment_thread do
    association :comment_thread
    association :user
    comment {"comment"}
  end
end
