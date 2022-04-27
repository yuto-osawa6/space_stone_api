FactoryBot.define do
  factory :like_thread do
    association :thered
    association :user
    goodbad {1}
  end
end
