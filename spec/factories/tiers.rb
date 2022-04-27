FactoryBot.define do
  factory :tier do
    tier {60}
    association :user
    association :product
    association :user_tier_group
    association :tier_group
  end
end