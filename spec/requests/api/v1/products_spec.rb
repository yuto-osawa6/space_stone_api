require 'rails_helper'
# binding.pry

RSpec.describe 'ProductsReds', type: :request do
  describe 'GET /red' do
    subject { get '/api/v1/products/red' }
    let!(:product_left) {create_list(:product_left,10)}

    # it 'プロダクト一覧が返却されること' do
    #   subject
    #   expect(json["products"].size).to eq(10)
    # end

    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /left' do
    subject { get '/api/v1/products/left' }
    let!(:product_left) {create_list(:product_left,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
  describe 'GET /show' do
    let!(:product) {create(:product_alice)}
    subject { get "/api/v1/products/#{Product.first.id}" }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /product_episords' do
    let!(:product) {create(:product_alice)}
    subject { get "/api/v1/products/product_episords",params:{product_id:Product.first.id}}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /product_review' do
    let!(:product) {create(:product_alice)}
    subject { get "/api/v1/products/product_review",params:{product_id:Product.first.id,page:1}}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /product_thread' do
    let!(:product) {create(:product_alice)}
    subject { get "/api/v1/products/product_thread",params:{product_id:Product.first.id,page:1} }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

  describe 'GET /seo' do
    let!(:product) {create(:product)}
    subject { get "/api/v1/products/#{Product.first.id}/seo"}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end

end