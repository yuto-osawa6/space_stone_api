FactoryBot.define do
  factory :janl do
    sequence(:name) { |n| "TEST_JANL#{n}"}
    created_at {Faker::Date.between(from: '2022-04-01', to: '2022-04-10')}
    updated_at {Faker::Date.between(from: '2022-04-01', to: '2022-04-10')}
  end
end
