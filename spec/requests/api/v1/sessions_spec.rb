require 'rails_helper'
RSpec.describe 'sessions', type: :request do
  describe 'get/login_check' do
    params = {
      body: {
        provider: "googleAuth",
        uid: "123456789",
        info: {
          email:"aaa@example.gmail.com",
          name: "sampleName",
          image:"url"
        }
      }
    }
    it 'ログイン成功' do
      post '/social_auth/callback',params:params
      get "/api/v1/session_user", headers: {
        "access-token": "#{json["headers"]["access-token"]}",
        "client": "#{json["headers"]["client"]}",
        "uid": "#{json["headers"]["uid"]}"
      }
      expect(json['is_login']).to eq(true)
    end
  end
end