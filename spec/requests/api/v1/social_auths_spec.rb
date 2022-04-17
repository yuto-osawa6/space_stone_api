require 'rails_helper'
# binding.pry

RSpec.describe 'SocialAuths', type: :request do
  describe 'POST /social_auth/callback' do
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
    subject { post '/social_auth/callback',params:params }
    it 'ステータス 200' do
      subject
      binding.pry
      expect(json['status']).to eq(200)
    end
  end
end
