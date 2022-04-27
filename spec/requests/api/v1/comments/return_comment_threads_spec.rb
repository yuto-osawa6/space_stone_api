require 'rails_helper'

RSpec.describe 'return_comment_threads', type: :request do
  describe 'get/index' do
    let!(:product) {create(:product_alice_thread_all)}
    subject { get "/api/v1/comment/return_comment_threads",params: {comment_thread_id:CommentThread.first.id,page:1}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end


  describe 'post/create' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { post "/api/v1/comment/return_comment_threads",params: {thread_id:Thered.first.id,comment_thread_id:CommentThread.first.id,return_comment_thread: {user_id:User.first.id,comment_thread_id:CommentThread.first.id,comment:"test"}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Threadが存在しない)' do
        post "/api/v1/comment/return_comment_threads",params: {thread_id:0,comment_thread_id:0,return_comment_thread: {user_id:User.first.id,comment_thread_id:0,comment:"test"}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentThreadが存在しない)' do
        post "/api/v1/comment/return_comment_threads",params: {thread_id:Thered.first.id,comment_thread_id:0,return_comment_thread: {user_id:User.first.id,comment_thread_id:0,comment:"test"}}
        expect(json['status']).to eq(410)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { delete "/api/v1/comment/return_comment_threads/#{ReturnCommentThread.first.id}",params: {thread_id:Thered.first.id,comment_thread_id:CommentThread.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Threadが存在しない)' do
        delete "/api/v1/comment/return_comment_threads/#{0}",params: {thread_id:0,comment_thread_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentThreadが存在しない)' do
        delete "/api/v1/comment/return_comment_threads/#{0}",params: {thread_id:Thered.first.id,comment_thread_id:0}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 420(ReturnCommentThreadが存在しない)' do
        delete "/api/v1/comment/return_comment_threads/#{0}",params: {thread_id:Thered.first.id,comment_thread_id:CommentThread.first.id}
        expect(json['status']).to eq(420)
      end
    end
  end

  describe 'post/returnreturn' do
    let!(:product) {create(:product_alice_thread_all)}
    context '正常' do
      subject { post "/api/v1/comment/return_comment_threads/returnreturn",params: {thread_id:Thered.first.id,return_comment_thread: {user_id:User.first.id,comment_thread_id:CommentThread.first.id,comment:"test"},return_return_comment_thread:{return_return_thread_id:ReturnCommentThread.first.id}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(threadが存在しない)' do
        post "/api/v1/comment/return_comment_threads/returnreturn",params: {thread_id:0,return_comment_thread: {user_id:User.first.id,comment_thread_id:0,comment:"test"},return_return_comment_thread:{return_return_thread_id:0}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(Commentthreadが存在しない)' do
        post "/api/v1/comment/return_comment_threads/returnreturn",params: {thread_id:Thered.first.id,return_comment_thread: {user_id:User.first.id,comment_thread_id:0,comment:"test"},return_return_comment_thread:{return_return_thread_id:0}}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 430(ReturnCommentthread(return_return_id)が存在しない)' do
        post "/api/v1/comment/return_comment_threads/returnreturn",params: {thread_id:Thered.first.id,return_comment_thread: {user_id:User.first.id,comment_thread_id:CommentThread.first.id,comment:"test"},return_return_comment_thread:{return_return_thread_id:0}}
        expect(json['status']).to eq(430)
      end
    end
  end
end