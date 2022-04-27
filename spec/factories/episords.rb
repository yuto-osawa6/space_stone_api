FactoryBot.define do
  factory :episord do
    association :product
    sequence(:title) { |n| "TEST_TITLE#{n}"}
    sequence(:arasuzi) { |n| "TEST_ARASUZI#{n}"}
    sequence(:episord) { |n| n}


  end
end

# `id` bigint NOT NULL AUTO_INCREMENT,
#   `product_id` bigint NOT NULL,
#   `title` varchar(255) DEFAULT NULL,
#   `arasuzi` text,
#   `episord` int DEFAULT NULL,
#   `season` int DEFAULT NULL,
#   `season_title` varchar(255) DEFAULT NULL,
#   `time` time DEFAULT NULL,
#   `image` text,
#   `created_at` datetime(6) NOT NULL,
#   `updated_at` datetime(6) NOT NULL,
#   `release_date` datetime DEFAULT NULL,