require 'rails_helper'
RSpec.describe 'thered', type: :request do
  # describe 'post/create' do
  #   let!(:product) {create(:product)}
  #   let!(:user) {create(:user)}
  #   it 'ステータス 200' do
  #     post "/api/v1/products/#{Product.first.id}/thereds",params:{
  #       thered:{
  #         product_id:Product.first.id,
  #         user_id:User.first.id,
  #         title:"title",
  #         discribe:"aa",
  #         content:"test",
  #         question_ids:[1]
  #       }, 
  #     }
  #     expect(json['status']).to eq(200)
  #   end
    # later-3後に制限かける可能性あり
    # it 'ステータス 450' do
    #   post "/api/v1/products/#{Product.first.id}/thereds",params:{
    #     thered:{
    #       product_id:Product.first.id,
    #       user_id:User.first.id,
    #       title:"title",
    #       discribe:"aa",
    #       content:"test"
    #       question_ids:[1]
    #     }, 
    #   }
    #   post "/api/v1/products/#{Product.first.id}/thereds",params:{
    #     thered:{
    #       product_id:Product.first.id,
    #       user_id:User.first.id,
    #       title:"title",
    #       discribe:"aa",
    #       content:"test"
    #       question_ids:[1]
    #     }, 
    #   }
    #   expect(json['status']).to eq(450)
    # end
  # end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_thered)}
    it 'ステータス 200' do
      delete "/api/v1/products/#{Product.first.id}/thereds/#{Thered.first.id}"
      expect(json['status']).to eq(200)
    end
    it 'ステータス 440' do
      delete "/api/v1/products/#{Product.first.id}/thereds/0"
      expect(json['status']).to eq(440)
    end
  end

  describe 'get/show' do
    let!(:product) {create(:product_alice_thread_all)}
    it 'ステータス 200' do
      get "/api/v1/products/#{Product.first.id}/thereds/#{Thered.first.id}"
      
      expect(json['status']).to eq(200)
    end
    it 'ステータス 440' do
      get "/api/v1/products/#{Product.first.id}/thereds/0"
      expect(json['status']).to eq(400)
    end
  end

end