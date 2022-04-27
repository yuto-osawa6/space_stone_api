FactoryBot.define do
  factory :year_product do
    association :product
    association :year
  end
end