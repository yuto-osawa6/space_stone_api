FactoryBot.define do
  factory :staff do
    sequence(:name) { |n| "TEST_JANL#{n}"}
  end
end
