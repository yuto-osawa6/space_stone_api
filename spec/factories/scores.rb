FactoryBot.define do
  factory :score do
    association :product
    association :user

    value {100}
    music {}
    animation {}
    story {}
    performance {}
    all {}
  end
end