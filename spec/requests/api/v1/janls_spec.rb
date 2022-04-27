require 'rails_helper'

RSpec.describe 'Cast', type: :request do
  describe 'get/index' do
    subject { get '/api/v1/janls' }
    let!(:janl) {create_list(:janl,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
  describe 'get/index' do
    subject { post '/api/v1/janls',params:{janls:{name:"test"}} }
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end