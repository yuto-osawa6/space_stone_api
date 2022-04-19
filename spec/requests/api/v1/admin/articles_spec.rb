require 'rails_helper'

RSpec.describe 'admin/articles', type: :request do
  describe 'post/create' do
    let!(:admin_user) {create(:user)}
    let!(:product_alice) {create(:product_alice)}
    subject { post '/api/v1/admin/articles',params:{article:{content:"aa",user_id:User.first.id,title:"aa",weekormonth:1,product_ids:Product.all.ids}}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end

  describe 'patch/update' do
    let!(:admin_user) {create(:user)}
    let!(:article) {create_list(:article,2,weekormonth:1,user:User.first)}
    let!(:product_alice) {create(:product_alice)}
    subject { patch "/api/v1/admin/articles/#{Article.first.id}",params:{article:{content:"newcontent",user_id:User.first.id,title:"aa",weekormonth:1,product_ids:Product.all.ids}}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end

  describe 'delete/destroy' do
    let!(:admin_user) {create(:user)}
    let!(:article) {create_list(:article,2,weekormonth:1,user:User.first)}
    # subject { patch "/api/v1/admin/articles/#{Article.first.id}",params:{article:{content:"aa",user_id:User.first.id,title:"aa",weekormonth:1,product_ids:Product.all.ids}}}
    it 'ステータス 200' do
      expect { delete "/api/v1/admin/articles/#{Article.first.id}" }.to change(Article, :count).by(-1)
      expect(json['status']).to eq(200)
    end
  end

  
end

# def update
#   @article = Article.find(params[:id])
#   if @article.update(create_params)
#     render json: {status:200}
#   else
#     render json: {status:500}
#   end
# end
# def destroy
#   begin
#     @article = Article.find(params[:id])
#     @article.destroy
#     render json: {status:200}
#   rescue => e
#     render json: {status:500}
#   end
# end