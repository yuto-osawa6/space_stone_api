FactoryBot.define do
  factory :user do
    provider
    uid
    # reset_password_token
    # reset_password_sent_at
    encrypted_password
    allow_password_change {false}
    # remember_created_at
    # name
    sequence(:nickname) { |n| "TEST_NICKNAME#{n}"}
    image {""}
    email {Faker::Internet.email}
    sign_in_count {0}
    # current_sign_in_at {}
    tokens {"tokens"}
    administrator_gold {false}
  end

  factory :admin_user, parent: :user  do
    administrator_gold {true}
  end
end

# t.string "provider", default: "email", null: false
# t.string "uid", default: "", null: false
# t.string "encrypted_password", default: "", null: false
# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.boolean "allow_password_change", default: false
# t.datetime "remember_created_at"
# t.string "name"
# t.string "nickname"
# t.text "image", size: :long
# t.string "email"
# t.integer "sign_in_count", default: 0, null: false
# t.datetime "current_sign_in_at"
# t.datetime "last_sign_in_at"
# t.string "current_sign_in_ip"
# t.string "last_sign_in_ip"
# t.text "tokens"
# t.datetime "created_at", precision: 6, null: false
# t.datetime "updated_at", precision: 6, null: false
# t.boolean "administrator_gold", default: false, null: false
# t.text "overview", size: :long
# t.text "background_image", size: :long