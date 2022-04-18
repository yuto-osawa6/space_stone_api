FactoryBot.define do
  factory :week do
    week {Time.current.ago(7.hours).prev_week(:monday).prev_week(:monday)}
  end
end