FactoryBot.define do
  factory :acsess_review do
    association :review
    count {10}
    date {Time.current.ago(1.hour)}
  end
end
