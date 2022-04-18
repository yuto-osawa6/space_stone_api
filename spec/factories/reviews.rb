
FactoryBot.define do
  factory :review do
    sequence(:title) { |n| "TEST_TITLE#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
    association :episord
    association :product
    association :user

  end
end