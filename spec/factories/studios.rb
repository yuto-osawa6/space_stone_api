FactoryBot.define do
  factory :studio do
    sequence(:company) { |n| "TEST_NAME#{n}"}
  end
end
