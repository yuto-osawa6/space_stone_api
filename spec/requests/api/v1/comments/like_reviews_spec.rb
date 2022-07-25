require 'rails_helper'

RSpec.describe 'like_reviews', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { post "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/like_reviews",params: {user_id:User.first.id,review_id:Review.first.id,goodbad:1}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        post "/api/v1/products/#{Product.first.id}/reviews/#{0}/like_reviews",params: {user_id:User.first.id,goodbad:1}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 500' do
        post "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/like_reviews",params: {user_id:User.first.id}
        expect(json['status']).to eq(500)
      end
    end
  end

  describe 'delete/destroy' do
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      it 'ステータス 200' do
        expect { delete "/api/v1/products/#{Product.first.id}/reviews/#{Review.first.id}/like_reviews/#{LikeReview.first.id}",params: {user_id:User.first.id,review_id:Review.first.id} }.to change(LikeReview, :count).by(-1)
        expect(json['status']).to eq(200)
      end
    end
    context '異常' do
      it 'ステータス 400' do
        delete "/api/v1/products/#{Product.first.id}/reviews/#{0}/like_reviews/#{LikeReview.first.id}",params: {user_id:User.first.id,review_id:Review.first.id}
        expect(json['status']).to eq(400)
      end
      it 'ステータス 440' do
        delete "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/like_reviews/#{0}",params: {user_id:0,review_id:Review.first.id}
        expect(json['status']).to eq(440)
      end
      # it 'ステータス 500' do
      #   delete "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/like_reviews/#{LikeReview.first.id}",params: {user_id:0,review_id:Review.first.id}
      #   expect(json['status']).to eq(500)
      # end
    end
  end

  describe 'post/create' do
    # nouse
    let!(:product) {create(:product_alice_review_all)}
    context '正常' do
      subject { get "/api/v1/products/#{Product.first.id}/reviews/#{Product.first.reviews[0].id}/like_reviews/check",params: {user_id:User.first.id,review_id:Review.first.id}}
      it 'ステータス 200' do
        subject
        expect(json['status']).to eq(201)
      end
    end
  end


end