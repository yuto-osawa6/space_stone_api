require 'rails_helper'

RSpec.describe 'Mains', type: :request do
  describe 'GET /top100' do
    context 'genre == 1のとき'do
      let!(:product_alice_like) {create_list(:product_alice_like,10)}
      subject { get '/api/v1/mains/top100',params:{genre:"1"} }
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返却されること' do
        subject
        expect(json['products'].size).to eq(10)
        expect(json['products'][0]['productStyles'].size).to eq(1)
        expect(json['products'][0]['productGenres'].size).to eq(1)
        expect(json['products'][0]['productYearSeason2'].size).to eq(2)
        expect(json['scores']['avgScore'].size).to eq(10)
      end
    end
    context 'genre == 2のとき'do
      let!(:product_alice) {create_list(:product_alice,10)}
      subject { get '/api/v1/mains/top100',params:{genre:"2"} }
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返却されること' do
        subject
        expect(json['products'].size).to eq(10)
        expect(json['products'][0]['productStyles'].size).to eq(1)
        expect(json['products'][0]['productGenres'].size).to eq(1)
        expect(json['products'][0]['productYearSeason2'].size).to eq(2)
        expect(json['scores']['avgScore'].size).to eq(10)
      end
    end
    context 'genre == 3のとき'do
      let!(:product_alice_acsess) {create_list(:product_alice_acsess,10)}
      subject { get '/api/v1/mains/top100',params:{genre:"3"} }
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返却されること' do
        subject
        expect(json['products'].size).to eq(10)
        expect(json['products'][0]['productStyles'].size).to eq(1)
        expect(json['products'][0]['productGenres'].size).to eq(1)
        expect(json['products'][0]['productYearSeason2'].size).to eq(2)
        expect(json['scores']['avgScore'].size).to eq(10)
      end
    end

    context 'genre == 4のとき'do
      let!(:product_alice) {create_list(:product_alice,10)}
      subject { get '/api/v1/mains/top100',params:{genre:"4"} }
      it 'ステータス 200' do
        subject
        expect(response.status).to eq(200)
      end
      it 'データーが返却されること' do
        subject
        expect(json['products'].size).to eq(10)
        expect(json['products'][0]['productStyles'].size).to eq(1)
        expect(json['products'][0]['productGenres'].size).to eq(1)
        expect(json['products'][0]['productYearSeason2'].size).to eq(2)
        expect(json['scores']['avgScore'].size).to eq(10)
      end
    end

    context 'genre == 5のとき'do
    let!(:product_alice_thered) {create_list(:product_alice_thered,10)}
    subject { get '/api/v1/mains/top100',params:{genre:"5"} }
    it 'ステータス 200' do
      subject
      expect(response.status).to eq(200)
    end
    it 'データーが返却されること' do
      subject
      expect(json['products'].size).to eq(10)
      expect(json['products'][0]['productStyles'].size).to eq(1)
      expect(json['products'][0]['productGenres'].size).to eq(1)
      expect(json['products'][0]['productYearSeason2'].size).to eq(2)
      expect(json['scores']['avgScore'].size).to eq(10)
    end
  end



  end

end