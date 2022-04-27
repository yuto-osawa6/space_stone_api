FactoryBot.define do
  factory :cast do
    sequence(:name) { |n| "TEST_NAME#{n}"}
  end
end
