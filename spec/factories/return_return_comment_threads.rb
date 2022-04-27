FactoryBot.define do
  factory :return_return_comment_thread do
    association :return_comment_thread
    association :return_return_thread
  end
end
