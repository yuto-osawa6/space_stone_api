
FactoryBot.define do
  factory :thered do
    sequence(:title) { |n| "TEST_TITLE#{n}"}
    sequence(:content) { |n| "TEST_CONTENT#{n}"}
    association :product
    association :user

    after(:create) do |thered|
      create(:thered_quesiton,thered:thered,question:Question.find(1))
    end

  end
end