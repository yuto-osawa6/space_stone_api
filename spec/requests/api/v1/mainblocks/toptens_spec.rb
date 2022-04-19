require 'rails_helper'

RSpec.describe 'MainBlocks/toptens', type: :request do
  describe 'GET /topten_l' do
    subject { get '/api/v1/mainblocks/toptens/topten_l' }
    let!(:product_alice_like) {create_list(:product_alice_like,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /topten_lm' do
    subject { get '/api/v1/mainblocks/toptens/topten_lm' }
    let!(:product_alice_like) {create_list(:product_alice_like,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /topten_a' do
    subject { get '/api/v1/mainblocks/toptens/topten_a' }
    let!(:product_alice_acsess) {create_list(:product_alice_acsess,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /topten_am' do
    subject { get '/api/v1/mainblocks/toptens/topten_am' }
    let!(:product_alice_acsess) {create_list(:product_alice_acsess,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /topten_s' do
    subject { get '/api/v1/mainblocks/toptens/topten_s' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /topten_sm' do
    subject { get '/api/v1/mainblocks/toptens/topten_sm' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end
  
  describe 'GET /topten_r' do
    subject { get '/api/v1/mainblocks/toptens/topten_r' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end
  describe 'GET /topten_rm' do
    subject { get '/api/v1/mainblocks/toptens/topten_rm' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

end