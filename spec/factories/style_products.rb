FactoryBot.define do
  factory :style_product do
    association :product
    association :style
  end
end
