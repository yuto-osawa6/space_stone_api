FactoryBot.define do
  factory :year_season_product do
    association :product
    association :kisetsu
    association :year
  end
end