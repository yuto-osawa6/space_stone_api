require 'rails_helper'

RSpec.describe 'comment_reviews', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_review_all)}
    let(:user) { User.first }
    let(:auth_tokens) { sign_in(user) }
    # let(:user) { { email: "momoko@test.com", password: "123456" } }
    context '正常' do
      # subject { post "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/comment_reviews",params: {comment_review: {user_id:User.first.id,review_id:Review.first.id,comment:"test"}, headers: auth_tokens}}
      it 'ステータス 200' do
        # user = User.first
        # auth_tokens = sign_in(user)
        # binding.pry
        # subject
        post "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/comment_reviews",params: {comment_review: {user_id:User.first.id,review_id:Review.first.id,comment:"test"}, headers: auth_tokens}
        # binding.pry
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Reviewが存在しない)' do
        post "/api/v1/products/#{Product.first.id}/reviews/#{0}/comment_reviews",params: {comment_review: {user_id: User.first.id,review_id: Review.first.id,comment: "test"}}
        expect(json['status']).to eq(400)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      it 'ステータス 200' do
        expect {delete "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/comment_reviews/#{CommentReview.first.id}",params: {user_id:User.first.id,review_id:Review.first.id}}.to change(CommentReview, :count).by(-1)
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400(Reviewが存在しない)' do
        delete "/api/v1/products/#{Product.first.id}/reviews/#{0}/comment_reviews/#{0}",params: {user_id:User.first.id,review_id:0}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 410(CommentReviewが存在しない)' do
        delete "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/comment_reviews/#{0}",params: {user_id:User.first.id,review_id:Review.first.id}
        expect(json['status']).to eq(410)
      end
    end
  end
end