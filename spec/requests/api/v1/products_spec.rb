require 'rails_helper'
# binding.pry

RSpec.describe 'ProductsReds', type: :request do
  describe 'GET /red' do
    subject { get '/api/v1/products/red' }
    let!(:product_left) {create_list(:product_left,10)}

    it 'プロダクト一覧が返却されること' do
      subject
      expect(json["products"].size).to eq(10)
    end

    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
end
# ----------------------------------------------------

RSpec.describe 'Products/Left', type: :request do
  describe 'GET /left' do
    subject { get '/api/v1/products/left' }
    let!(:product_left) {create_list(:product_left,10)}
    # let!(:style) {create_list(:style,3)}
    # let!(:janl) {create_list(:janl,3)}
    it 'ステータス 200' do
      subject
      # binding.pry
      expect(response.status).to eq(200)
    end
  end
end