require 'rails_helper'

RSpec.describe 'like_comment_threads', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { post "/api/v1/comment/like_comment_threads",params: {thread_id:Thered.first.id,like_comment_thread:{user_id:User.first.id,comment_thread_id:CommentThread.first.id,goodbad:1}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        post "/api/v1/comment/like_comment_threads",params: {thread_id:0,like_comment_thread:{user_id:User.first.id,comment_thread_id:0,goodbad:1}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        post "/api/v1/comment/like_comment_threads",params: {thread_id:Thered.first.id,like_comment_thread:{user_id:User.first.id,comment_thread_id:0,goodbad:1}}
        expect(json['status']).to eq(410)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { delete "/api/v1/comment/like_comment_threads/#{LikeCommentThread.first.id}",params: {thread_id:Thered.first.id,user_id:User.first.id,comment_thread_id:CommentThread.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        delete "/api/v1/comment/like_comment_threads/#{0}",params: {thread_id:0,user_id:User.first.id,comment_thread_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        delete "/api/v1/comment/like_comment_threads/#{0}",params: {thread_id:Thered.first.id,user_id:User.first.id,comment_thread_id:0}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 440' do
        delete "/api/v1/comment/like_comment_threads/#{LikeCommentThread.first.id}",params: {thread_id:Thered.first.id,user_id:User.first.id,comment_thread_id:CommentThread.first.id}
        delete "/api/v1/comment/like_comment_threads/#{0}",params: {thread_id:Thered.first.id,user_id:User.first.id,comment_thread_id:CommentThread.first.id}
        expect(json['status']).to eq(440)
      end
    end
  end


end