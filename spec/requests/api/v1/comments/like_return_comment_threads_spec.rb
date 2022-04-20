require 'rails_helper'

RSpec.describe 'like_return_comment_threads', type: :request do
  describe 'post/create' do
    context '正常' do
      let!(:product) {create(:product_alice_thread_all)}
      it 'ステータス 200' do
        post "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads",params: {
          like_return_comment_thread:{
            user_id:User.first.id,
            return_comment_thread_id:ReturnCommentThread.first.id,
            goodbad:1
          },
          thread_id:Thered.first.id,
          comment_thread_id:CommentThread.first.id
        }
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      let!(:product) {create(:product_alice_thread_all)}
      it 'ステータス 400' do
        post "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads",params: {
          like_return_comment_thread:{
            user_id:User.first.id,
            return_comment_thread_id:0,
            goodbad:1
          },
          thread_id:0,
          comment_thread_id:0
        }
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        post "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads",params: {
          like_return_comment_thread:{
            user_id:User.first.id,
            return_comment_thread_id:0,
            goodbad:1
          },
          thread_id:Thered.first.id,
          comment_thread_id:0
        }
        expect(json['status']).to eq(410)
      end
      it 'ステータス 420' do
        post "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads",params: {
          like_return_comment_thread:{
            user_id:User.first.id,
            return_comment_thread_id:0,
            goodbad:1
          },
          thread_id:Thered.first.id,
          comment_thread_id:CommentThread.first.id
        }
        expect(json['status']).to eq(420)
      end
    end
  end

  describe 'delete/destroy' do
    context '正常' do
      let!(:product) {create(:product_alice_thread_all)}
      it 'ステータス 200' do
        delete "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads/#{LikeReturnCommentThread.first.id}",params: {
          thread_id:Thered.first.id,
          comment_thread_id:CommentThread.first.id,
          return_comment_thread_id:ReturnCommentThread.first.id,
          user_id:User.first.id
        }
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      let!(:product) {create(:product_alice_thread_all)}
      it 'ステータス 400' do
        delete "/api/v1/comment/return_comment_threads/#{0}/like_return_comment_threads/#{LikeReturnCommentThread.first.id}",params: {
          thread_id:0,
          comment_thread_id:0,
          return_comment_thread_id:0,
          user_id:User.first.id
        }
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        delete "/api/v1/comment/return_comment_threads/#{0}/like_return_comment_threads/#{LikeReturnCommentThread.first.id}",params: {
          thread_id:Thered.first.id,
          comment_thread_id:0,
          return_comment_thread_id:0,
          user_id:User.first.id
        }
        expect(json['status']).to eq(410)
      end
      it 'ステータス 420' do
        delete "/api/v1/comment/return_comment_threads/#{0}/like_return_comment_threads/#{LikeReturnCommentThread.first.id}",params: {
          thread_id:Thered.first.id,
          comment_thread_id:CommentThread.first.id,
          return_comment_thread_id:0,
          user_id:User.first.id
        }
        expect(json['status']).to eq(420)
      end
      it 'ステータス 440' do
        delete "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}/like_return_comment_threads/#{LikeReturnCommentThread.first.id}",params: {
          thread_id:Thered.first.id,
          comment_thread_id:CommentThread.first.id,
          return_comment_thread_id:ReturnCommentThread.first.id,
          user_id:0
        }
        expect(json['status']).to eq(440)
      end
    end
  end

end