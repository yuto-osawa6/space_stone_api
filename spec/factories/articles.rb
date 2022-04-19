FactoryBot.define do
  factory :article do
    association :user
    title {"TITLE"}
    content {"TEST_CONTENT"}

    after(:create) do |article|
      create(:acsess_article,article:article)
    end

  end
end

# `content` longtext,
# `title` varchar(255) DEFAULT NULL,
# `weekormonth` tinyint(1) DEFAULT NULL,
# `time` datetime DEFAULT NULL,
# `created_at` datetime(6) NOT NULL,
# `updated_at` datetime(6) NOT NULL,
# `user_id` bigint NOT NULL,