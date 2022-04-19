require 'rails_helper'

RSpec.describe 'like_threads', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { post "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/like_threads",params: {user_id:User.first.id,thered_id:Thered.first.id,goodbad:1}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        post "/api/v1/products/#{Product.first.id}/thereds/#{0}/like_threads",params: {user_id:User.first.id,goodbad:1}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 500' do
        post "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/like_threads",params: {user_id:User.first.id}
        expect(json['status']).to eq(500)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      it 'ステータス 200' do
        expect { delete "/api/v1/products/#{Product.first.id}/thereds/#{Thered.first.id}/like_threads/#{LikeThread.first.id}",params: {user_id:User.first.id,thered_id:Thered.first.id} }.to change(LikeThread, :count).by(-1)
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        delete "/api/v1/products/#{Product.first.id}/thereds/#{0}/like_threads/#{LikeThread.first.id}",params: {user_id:User.first.id,thered_id:Thered.first.id}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 440' do
        delete "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/like_threads/#{0}",params: {user_id:0,thered_id:Thered.first.id}
        expect(json['status']).to eq(440)
      end
      # it 'ステータス 500' do
      # end
    end
  end

  describe 'post/create' do
    # nouse
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { get "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/like_threads/check",params: {user_id:User.first.id,thered_id:Thered.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
  end


end