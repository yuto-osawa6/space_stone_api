# require 'rails_helper'

# RSpec.describe 'Chats', type: :request do
#   describe 'post/create' do
#     let!(:product) {create(:product)}
#     let!(:user) {create(:user)}
#     subject { post "/api/v1/products/#{Product.first.id}/chats",params:{chat:{message:"aa",user_id:User.first.id,product_id:Product.first.id}} }
#     it 'ステータス 200' do
#       subject
#       expect(response.status).to eq(200)
#     end
#   end
# end