FactoryBot.define do
  factory :year do
    # sequence(:year) { |n| "2022-01-0#{n}"}
    year {"2022-01-01"}

    # sequence(:nickname) { |n| "TEST_NICKNAME#{n}"}
    # created_at
    # del
    # after(:create) do |product|
    #   create_list(:style_product, 1, product: product, style: create(:style))
    # end
    
  end
end