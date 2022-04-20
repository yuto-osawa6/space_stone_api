require 'rails_helper'

RSpec.describe 'comment_reviews', type: :request do
  describe 'get/index' do
    let!(:product) {create(:product_alice_review_all)}
    subject { get "/api/v1/comment/return_comment_reviews",params: {comment_review_id:CommentReview.first.id,page:1}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end


  describe 'post/create' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { post "/api/v1/comment/return_comment_reviews",params: {review_id:Review.first.id,comment_review_id:CommentReview.first.id,return_comment_review: {user_id:User.first.id,comment_review_id:CommentReview.first.id,comment:"test"}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Reviewが存在しない)' do
        post "/api/v1/comment/return_comment_reviews",params: {review_id:0,comment_review_id:0,return_comment_review: {user_id:User.first.id,comment_review_id:0,comment:"test"}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentReviewが存在しない)' do
        post "/api/v1/comment/return_comment_reviews",params: {review_id:Review.first.id,comment_review_id:0,return_comment_review: {user_id:User.first.id,comment_review_id:0,comment:"test"}}
        expect(json['status']).to eq(410)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { delete "/api/v1/comment/return_comment_reviews/#{ReturnCommentReview.first.id}",params: {review_id:Review.first.id,comment_review_id:CommentReview.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Reviewが存在しない)' do
        delete "/api/v1/comment/return_comment_reviews/#{0}",params: {review_id:0,comment_review_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentReviewが存在しない)' do
        delete "/api/v1/comment/return_comment_reviews/#{0}",params: {review_id:Review.first.id,comment_review_id:0}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 420(ReturnCommentReviewが存在しない)' do
        delete "/api/v1/comment/return_comment_reviews/#{0}",params: {review_id:Review.first.id,comment_review_id:CommentReview.first.id}
        expect(json['status']).to eq(420)
      end
    end
  end

  describe 'post/returnreturn' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { post "/api/v1/comment/return_comment_reviews/returnreturn",params: {review_id:Review.first.id,return_comment_review: {user_id:User.first.id,comment_review_id:CommentReview.first.id,comment:"test"},return_return_comment_review:{return_return_id:ReturnCommentReview.first.id}}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Reviewが存在しない)' do
        post "/api/v1/comment/return_comment_reviews/returnreturn",params: {review_id:0,return_comment_review: {user_id:User.first.id,comment_review_id:0,comment:"test"},return_return_comment_review:{return_return_id:0}}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentReviewが存在しない)' do
        post "/api/v1/comment/return_comment_reviews/returnreturn",params: {review_id:Review.first.id,return_comment_review: {user_id:User.first.id,comment_review_id:0,comment:"test"},return_return_comment_review:{return_return_id:0}}
        expect(json['status']).to eq(410)
      end
      it 'ステータス 430(ReturnCommentReview(return_return_id)が存在しない)' do
        post "/api/v1/comment/return_comment_reviews/returnreturn",params: {review_id:Review.first.id,return_comment_review: {user_id:User.first.id,comment_review_id:CommentReview.first.id,comment:"test"},return_return_comment_review:{return_return_id:0}}
        expect(json['status']).to eq(430)
      end
    end
  end


end