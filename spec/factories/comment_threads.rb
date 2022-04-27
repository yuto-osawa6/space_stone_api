FactoryBot.define do
  factory :comment_thread do
    association :thered
    association :user
    comment {"comment"}
  end
end
