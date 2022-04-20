require 'rails_helper'
# binding.pry

RSpec.describe '', type: :request do
  describe 'patch/setting' do
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      patch '/api/v1/users/setting',params:{
        user_id:User.first.id,
        nickname:"aiueo",
        user:{
          user_id:User.first.id
        }
      }
      expect(json['status']).to eq(200)
    end
  end
  describe 'patch/background' do
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      patch '/api/v1/users/background',params:{
        user_id:User.first.id,
        background_image: "background",
        user:{
          user_id:User.first.id
        }
      }
      expect(json['status']).to eq(200)
    end
  end
  describe 'patch/overview' do
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      patch '/api/v1/users/overview',params:{
        user_id:User.first.id,
        overview:"overview",
        user:{
          user_id:User.first.id
        }
      }
      expect(json['status']).to eq(200)
    end
  end
  describe 'get/show' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      get "/api/v1/users/#{User.first.id}",params:{
        user_id:User.first.id
      }
      expect(json['status']).to eq(200)
    end
  end
  describe 'get/likes' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      get "/api/v1/users/likes",params:{
        user_id:User.first.id
      }
      expect(response.status).to eq(200)
    end
  end
  describe 'get/likeGenres' do
    let!(:product) {create(:product_alice)}
    it 'ステータス 200' do
      get "/api/v1/users/likeGenres",params:{
        user_id:User.first.id
      }
      expect(response.status).to eq(200)
    end
  end
  describe 'get/mytiers' do
    let!(:product) {create(:product_alice_tier)}
    it 'ステータス 200' do
      get "/api/v1/users/mytiers",params:{
        user_id:User.first.id
      }
      expect(response.status).to eq(200)
    end
  end
  describe 'delete/destroy' do
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      delete "/api/v1/users/#{User.first.id}"
      expect(response.status).to eq(200)
    end
  end
end