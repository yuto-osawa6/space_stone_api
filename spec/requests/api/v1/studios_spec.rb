require 'rails_helper'

RSpec.describe 'Studios', type: :request do
  describe 'get/index' do
    subject { get '/api/v1/studios' }
    let!(:studio) {create_list(:studio,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
  describe 'get/index' do
    subject { post '/api/v1/studios',params:{studios:{company:"test"}} }
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end