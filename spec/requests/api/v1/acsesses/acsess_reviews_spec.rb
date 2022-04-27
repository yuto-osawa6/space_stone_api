require 'rails_helper'

RSpec.describe 'Acsesses/acsess_reviews', type: :request do
  describe 'POST /create' do
    let!(:product_alice) {create(:product_alice)}
    subject { post '/api/v1/acsesses/acsess_reviews',params:{review_id:Review.first.id,date:Time.current,acsess_review:{review_id:Review.first.id,date:Time.current}}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end