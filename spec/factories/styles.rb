FactoryBot.define do
  factory :style do
    sequence(:name) { |n| "TEST_STYLE#{n}"}

    # created_at {Faker::Date.between(from: '2022-04-01', to: '2022-04-10')}
    # updated_at {Faker::Date.between(from: '2022-04-01', to: '2022-04-10')}
    # after(:create) do |style|
    #   create_list(:style_product, 3, product: product, style: create(:style))
    # end

  end
end