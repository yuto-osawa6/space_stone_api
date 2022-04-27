FactoryBot.define do
  factory :like do
    association :product
    association :user
  end
end
