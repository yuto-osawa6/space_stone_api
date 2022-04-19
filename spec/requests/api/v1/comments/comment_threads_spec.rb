require 'rails_helper'

RSpec.describe 'comment_threads', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { post "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/comment_threads",params: {comment_thread: {user_id:User.first.id,thered_id:Thered.first.id,comment:"test"}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Threadが存在しない)' do
        post "/api/v1/products/#{Product.first.id}/thereds/#{0}/comment_threads",params: {comment_thread: {user_id: User.first.id,thered_id: Thered.first.id,comment: "test"}}
        expect(json['status']).to eq(400)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      it 'ステータス 200' do
        expect {delete "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/comment_threads/#{CommentThread.first.id}",params: {user_id:User.first.id,thered_id:Thered.first.id}}.to change(CommentThread, :count).by(-1)
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Threadが存在しない)' do
        delete "/api/v1/products/#{Product.first.id}/thereds/#{0}/comment_threads/#{0}",params: {user_id:User.first.id,thered_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentThreadが存在しない)' do
        delete "/api/v1/products/#{Product.first.id}/thereds/#{Product.first.thereds[0].id}/comment_threads/#{0}",params: {user_id:User.first.id,thered_id:Thered.first.id}
        expect(json['status']).to eq(410)
      end
    end
  end
end