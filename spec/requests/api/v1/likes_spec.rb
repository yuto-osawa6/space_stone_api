require 'rails_helper'

RSpec.describe 'Likes', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      post "/api/v1/products/#{Product.first.id}/likes",params:{
        like:{
          product_id:Product.first.id,
          user_id:User.first.id
        }
        
      }
      expect(json["status"]).to eq(200)
    end
    it 'ステータス 440' do
      post "/api/v1/products/#{0}/likes",params:{
        like:{
          product_id:0,
          user_id:User.first.id
        }
      }
      expect(json["status"]).to eq(440)
    end
  end
  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_like)}
    it 'ステータス 200' do
      delete "/api/v1/products/#{Product.first.id}/likes/#{Like.first.id}",params:{
        like:{
          user_id:User.first.id
        },
        product_id:Product.first.id
      }
      expect(json["status"]).to eq(200)
    end
    it 'ステータス 440' do
      delete "/api/v1/products/#{0}/likes/#{Like.first.id}",params:{
        like:{
          user_id:User.first.id
        },
        product_id:0
      }
      expect(json["status"]).to eq(440)
    end
  end

  describe 'post/check' do
    let!(:product) {create(:product_alice_like)}
    it 'ステータス 200' do
      get "/api/v1/products/#{Product.first.id}/likes/check",params:{
        product_id:Product.first.id,
        user_id:User.first.id
      }
      expect(response.status).to eq(200)
    end
  end
end