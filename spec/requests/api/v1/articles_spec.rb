require 'rails_helper'
RSpec.describe 'articles', type: :request do
  describe 'get/index' do
    let!(:product) {create(:product_alice_article)}
    it 'ステータス 200' do
      get "/api/v1/articles",params:{product_id:Product.first.id,weekormonth:1}
      expect(response.status).to eq(200)
      expect(json["articles"].size).to eq(1)
    end
  end

  describe 'get/show' do
    let!(:product) {create(:product_alice_article)}
    it 'ステータス 200' do
      get "/api/v1/articles/#{Article.first.id}",params:{article_id:Article.first.id}
      expect(response.status).to eq(200)
    end
  end
  
  describe 'get/article_associate' do
    let!(:product) {create(:product_alice_article)}
    it 'ステータス 200' do
      get "/api/v1/articles/article_associate",params:{article_id:Article.first.id}
      expect(response.status).to eq(200)
    end
  end
end