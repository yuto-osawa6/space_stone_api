FactoryBot.define do
  factory :user_tier_group do
    association :user
    association :tier_group
  end
end