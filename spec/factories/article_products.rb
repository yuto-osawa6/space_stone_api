FactoryBot.define do
  factory :article_product do
    association :article
    association :product
  end
end