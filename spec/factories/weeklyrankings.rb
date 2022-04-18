FactoryBot.define do
  factory :weeklyranking do
    weekly {Time.current}
    sequence(:count) {|n| n}
    association :week
    association :product
  end
end