require 'rails_helper'

RSpec.describe 'admin/news', type: :request do
  describe 'post/create' do
    subject { post '/api/v1/admin/news',params:{newmessage:{judge:1,title:"aa",description:"aa"}}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end