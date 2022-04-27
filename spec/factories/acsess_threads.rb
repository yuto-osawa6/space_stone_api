FactoryBot.define do
  factory :acsess_thread do
    association :thered
    count {10}
    date {Time.current.ago(1.hour)}
  end
end
