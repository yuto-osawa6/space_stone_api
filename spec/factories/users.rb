FactoryBot.define do
  factory :user do
    provider {"google"}
    sequence(:uid) { |n| "12345#{n}"}
    # reset_password_token
    # reset_password_sent_at
    # encrypted_password
    allow_password_change {false}
    # remember_created_at
    # name
    sequence(:nickname) { |n| "TEST_NICKNAME#{n}"}
    image {""}
    email {Faker::Internet.email}
    sign_in_count {0}
    # current_sign_in_at {}
    # tokens {"{"token":"aaaaaaaa"}"}
    # {"8KJsthVCU1FOas6uJjWKbw":{"token":"$2a$10$2oNi2vRNMx4QXoX1JnRQ3uxYI4nYMc8AuedbD85U4v0qcTGNrc4Pe","expiry":1650620283,"updated_at":"2022-04-08T18:38:03+09:00"}}
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