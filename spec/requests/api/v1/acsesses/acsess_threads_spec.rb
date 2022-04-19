require 'rails_helper'

RSpec.describe 'Acsesses/acsess_threads', type: :request do
  describe 'POST /create' do
    let!(:product_alice_thered) {create(:product_alice_thered)}
    subject { post '/api/v1/acsesses/acsess_threads',params:{thered_id:Thered.first.id,date:Time.current,acsess_thread:{thered_id:Thered.first.id,date:Time.current}}}
    it 'ステータス 200' do
      subject
      # binding.pry
      expect(json['status']).to eq(200)
    end
  end
end