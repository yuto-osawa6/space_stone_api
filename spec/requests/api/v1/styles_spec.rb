require 'rails_helper'

RSpec.describe 'styles', type: :request do
  describe 'get/index' do
    subject { get '/api/v1/styles' }
    let!(:staff) {create_list(:staff,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
  end
  describe 'get/index' do
    subject { post '/api/v1/styles',params:{styles:{name:"test"}} }
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end