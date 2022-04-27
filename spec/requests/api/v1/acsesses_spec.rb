require 'rails_helper'
RSpec.describe 'acsesses', type: :request do
  describe 'post/create' do
    let!(:product) {create(:product)}
    it 'ステータス 200' do
      post "/api/v1/products/#{Product.first.id}/acsesses",params:{acsess:{product_id:Product.first.id},current_time:Time.current}
      expect(json['status']).to eq(200)
    end
  end
end