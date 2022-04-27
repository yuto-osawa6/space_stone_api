require 'rails_helper'

RSpec.describe 'like_comment_reviews', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { post "/api/v1/comment/like_comment_reviews",params: {review_id:Review.first.id,like_comment_review:{user_id:User.first.id,comment_review_id:CommentReview.first.id,goodbad:1}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        post "/api/v1/comment/like_comment_reviews",params: {review_id:0,like_comment_review:{user_id:User.first.id,comment_review_id:0,goodbad:1}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        post "/api/v1/comment/like_comment_reviews",params: {review_id:Review.first.id,like_comment_review:{user_id:User.first.id,comment_review_id:0,goodbad:1}}
        expect(json['status']).to eq(410)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { delete "/api/v1/comment/like_comment_reviews/#{LikeCommentReview.first.id}",params: {review_id:Review.first.id,user_id:User.first.id,comment_review_id:CommentReview.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        delete "/api/v1/comment/like_comment_reviews/#{0}",params: {review_id:0,user_id:User.first.id,comment_review_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410' do
        delete "/api/v1/comment/like_comment_reviews/#{0}",params: {review_id:Review.first.id,user_id:User.first.id,comment_review_id:0}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 440' do
        delete "/api/v1/comment/like_comment_reviews/#{LikeCommentReview.first.id}",params: {review_id:Review.first.id,user_id:User.first.id,comment_review_id:CommentReview.first.id}
        delete "/api/v1/comment/like_comment_reviews/#{0}",params: {review_id:Review.first.id,user_id:User.first.id,comment_review_id:CommentReview.first.id}
        expect(json['status']).to eq(440)
      end
    end
  end


end