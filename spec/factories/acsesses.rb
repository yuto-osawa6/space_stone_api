FactoryBot.define do
  factory :acsess do
    sequence(:count) { |n| n}
    association :product
    date {Time.current.ago(1.hours)}
  end
end
