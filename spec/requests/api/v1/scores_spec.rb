require 'rails_helper'
RSpec.describe 'scores', type: :request do
  describe 'post/create' do
    # let!(:product) {create(:product_alice)}
    let!(:product) {create(:product)}
    let!(:user) {create(:user)}
    it 'ステータス 200' do
      post "/api/v1/products/#{Product.first.id}/scores",params:{
        score:{
          product_id:Product.first.id,
          user_id:User.first.id,
          value:100,
          music:100,
          performance:100,
          story:100,
          animation:100,
          character:100,
          all:100,
        }
    }
      expect(json['status']).to eq(200)
    end
  end
  describe 'post/create' do
    let!(:product) {create(:product_alice)}
    # let!(:product) {create(:product)}
    # let!(:user) {create(:user)}
    it 'ステータス 200' do
      patch "/api/v1/products/#{Product.first.id}/scores/#{Score.first.id}",params:{
        score:{
          product_id:Product.first.id,
          user_id:User.first.id,
          value:100,
          music:100,
          performance:70,
          story:100,
          animation:70,
          character:70,
          all:60,
        }
    }
      expect(json['status']).to eq(200)
    end
  end
end