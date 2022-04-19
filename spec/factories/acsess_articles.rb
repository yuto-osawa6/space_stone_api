FactoryBot.define do
  factory :acsess_article do
    association :article
    count {10}
    date {Time.current.ago(1.hour)}
  end
end
