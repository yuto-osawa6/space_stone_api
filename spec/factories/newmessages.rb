FactoryBot.define do
  factory :newmessage do
    sequence(:title){|n| "TEST_TITLE#{n}"}
    description {"aaa"}
  end
end
