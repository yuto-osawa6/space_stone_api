require 'rails_helper'

RSpec.describe 'MainBlocks/Mains', type: :request do
  describe 'GET /new_netflix' do
    subject { get '/api/v1/mainblocks/mains/new_netflix' }
    let!(:product_alice) {create_list(:product_alice_new_netflix,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end

  describe 'GET /pickup' do
    subject { get '/api/v1/mainblocks/mains/pickup' }
    let!(:product_alice) {create_list(:product_alice_pickup,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
      expect(json["products2"].size).to eq(10)
    end
  end
  
  describe 'GET /new_message' do
    context 'jugde==allのとき' do
      subject { get '/api/v1/mainblocks/mains/new_message',params:{active:"0"} }
      let!(:newmessage) {create_list(:newmessage,10,judge:1)}
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返ってくるか' do
        subject
        expect(json["length"]).to eq(10)
      end
    end
  end

  describe 'GET /new_message' do
    context 'jugde==1のとき' do
      subject { get '/api/v1/mainblocks/mains/new_message',params:{active:"1"} }
      let!(:newmessage) {create_list(:newmessage,10,judge:1)}
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返ってくるか' do
        subject
        expect(json["length"]).to eq(10)
      end
    end
  end

  describe 'GET /new_message' do
    context 'jugde==2のとき' do
      subject { get '/api/v1/mainblocks/mains/new_message',params:{active:"2"} }
      let!(:newmessage) {create_list(:newmessage,10,judge:2)}
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返ってくるか' do
        subject
        expect(json["length"]).to eq(10)
      end
    end
  end

  describe 'GET /new_message' do
    context 'jugde==3のとき' do
      subject { get '/api/v1/mainblocks/mains/new_message',params:{active:"3"} }
      let!(:newmessage) {create_list(:newmessage,10,judge:3)}
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返ってくるか' do
        subject
        expect(json["length"]).to eq(10)
      end
    end
  end

  describe 'GET /calendar' do
    subject { get '/api/v1/mainblocks/mains/calendar' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["episordStart"].size).to eq(20)
    end
  end

  describe 'GET /worldclass' do
    subject { get '/api/v1/mainblocks/mains/worldclass' }
    let!(:product_alice) {create_list(:product_alice,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["worldRanking"].size).to eq(10)
    end
  end
 

  describe 'GET /ranking ' do
    subject { get '/api/v1/mainblocks/mains/ranking' }
    let!(:product_alice_ranking) {create_list(:product_alice_ranking,10)}
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返ってくるか' do
      subject
      expect(json["products"].size).to eq(10)
    end
  end


  describe 'POST /vote ' do
    let!(:product_alice_ranking) {create_list(:product_alice_ranking,10)}
    context '正常'do
      it 'ステータス 200' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:Product.first.id,episord_ids:Product.first.episords.ids}
        expect(json["status"]).to eq(200)
      end
      it 'データーが返ってくるか' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:Product.first.id,episord_ids:Product.first.episords.ids}
        expect(json["products"].size).to eq(10)
      end
    end
    context '異常'do
      it 'ステータス 200' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:9021}
        binding.pry
        expect(json["status"]).to eq(500)
      end
    end
  end

  describe 'POST /create_tier ' do
    let!(:product_alice_ranking) {create_list(:product_alice_ranking,10)}
    context '正常'do
      it 'ステータス 200' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:Product.first.id,episord_ids:Product.first.episords.ids}
        expect(json["status"]).to eq(200)
      end
      it 'データーが返ってくるか' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:Product.first.id,episord_ids:Product.first.episords.ids}
        expect(json["products"].size).to eq(10)
      end
    end
    context '異常'do
      it 'ステータス 200' do
        post '/api/v1/mainblocks/mains/vote',params:{product_id:9021}
        binding.pry
        expect(json["status"]).to eq(500)
      end
    end
  end

end