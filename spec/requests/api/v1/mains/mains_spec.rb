require 'rails_helper'

RSpec.describe 'Mains', type: :request do
  describe 'GET /genressearch' do
    let!(:janl) {create_list(:janl,10)}
    subject { get '/api/v1/mains/genressearch' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json["genres"].size).to eq(10)
    end
  end

  describe 'GET /castssearch' do
    subject { get '/api/v1/mains/castssearch' }
    let!(:cast) {create_list(:cast,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json["casts"].size).to eq(10)
    end
  end

  describe 'GET /studiossearch' do
    subject { get '/api/v1/mains/studiossearch' }
    let!(:studio) {create_list(:studio,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json["studios"].size).to eq(10)
    end
  end

  describe 'GET /productSearch' do
    let!(:product) {create_list(:product,10)}
    subject { get '/api/v1/mains/productSearch' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /findcast' do
    let!(:cast) {create_list(:cast,10)}
    subject { get '/api/v1/mains/findcast',params:{id:Cast.all[0].id} }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json.size).to eq(1)
    end
  end

  

  # sessonを扱うテスト
  # describe 'GET /grid' do
  #   # subject { get '/api/v1/mains/grid',params:{grid_id:"01"} }
  #   context "grid_id が空の場合"do
  #     it 'ステータス 200' do
  #       get '/api/v1/mains/grid',params:{grid_id:""}
  #       expect(response.status).to eq(200)
  #     end
  #     it 'データーが返却されること' do
  #       get '/api/v1/mains/grid',params:{grid_id:""}
  #       binding.pry
  #       # expect(json.size).to eq(1)
  #     end
  #   end
  #   context "grid_id == 01"do
  #     it 'ステータス 200' do
  #       get '/api/v1/mains/grid',params:{grid_id:"01"}
  #       expect(response.status).to eq(200)
  #     end
  #     it 'データーが返却されること' do
  #       get '/api/v1/mains/grid',params:{grid_id:"01"}
  #       binding.pry
  #       # expect(json.size).to eq(1)
  #     end
  #   end
  # end

  describe 'GET /emotion' do
    # let!(:cast) {create_list(:cast,10)}
    subject { get '/api/v1/mains/emotion' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json["emotionList"].size).to be > 0
    end
  end

  describe 'GET /weekliy_main' do
    let!(:product_alice_week) {create_list(:product_alice_week,10)}
    subject { get '/api/v1/mains/weekliy_main' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json['weekly'].size).to be > 0
    end
  end


  describe 'GET /tier_main' do
    let!(:product_alice_tier) {create_list(:product_alice_tier,2)}
    subject { get '/api/v1/mains/tier_main' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      # binding.pry
      expect(json["tierMain"][0]["avg"].size).to eq(2)
      expect(json["tierMain"][0]["products"].size).to eq(2)
      # expect(json["tierGroupLength"]).to eq(4)
    end
  end

  

  describe 'GET /user_search' do
    let!(:user) {create_list(:user,2)}
    subject { get '/api/v1/mains/user_search' }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json['user'].size).to eq(1)
    end
  end
  
  

end