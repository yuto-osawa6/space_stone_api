require 'rails_helper'
RSpec.describe 'reviews', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product)}
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      post "/api/v1/products/#{Product.first.id}/reviews",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(200)
    end
    it 'ステータス 450' do
      post "/api/v1/products/#{Product.first.id}/reviews",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      post "/api/v1/products/#{Product.first.id}/reviews",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(450)
    end
  end

  describe 'patch/update' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      patch "/api/v1/products/#{Product.first.id}/reviews/#{Review.first.id}",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(200)
    end
    it 'ステータス 460' do
      patch "/api/v1/products/#{Product.first.id}/reviews/#{0}",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(460)
    end
  end

  describe 'patch/update2' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      patch "/api/v1/products/#{Product.first.id}/reviews/#{Review.first.id}/update2",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(200)
    end
    it 'ステータス 460' do
      patch "/api/v1/products/#{Product.first.id}/reviews/0/update2",params:{
        review:{
          product_id:Product.first.id,
          user_id:User.first.id,
          emotion_ids:[1,2,3],
          title:"title",
          discribe:"aa",
          content:"test"
        }, 
      }
      expect(json['status']).to eq(460)
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      delete "/api/v1/products/#{Product.first.id}/reviews/#{Review.first.id}"
      expect(json['status']).to eq(200)
    end
    it 'ステータス 440' do
      delete "/api/v1/products/#{Product.first.id}/reviews/0"
      expect(json['status']).to eq(440)
    end
  end

  describe 'get/show' do
    let!(:product) {create(:product_alice_review_all)}
    it 'ステータス 200' do
      get "/api/v1/products/#{Product.first.id}/reviews/#{Review.first.id}"
      expect(json['status']).to eq(200)
    end
    it 'ステータス 440' do
      get "/api/v1/products/#{Product.first.id}/reviews/0"
      expect(json['status']).to eq(400)
    end
  end

end