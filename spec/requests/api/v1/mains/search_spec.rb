require 'rails_helper'
# binding.pry

RSpec.describe 'Main/Search', type: :request do
  describe 'GET /search' do
    let!(:product_left) {create_list(:product_alice,10)}
    params = {
      q: {
        janls_id_in:[""],
        casts_id_in:[""],
        studios_id_in:[""],
        styles_id_eq:"",
      },
      page:1
    }
    params2 = {
      q: {
        janls_id_in:[""],
        casts_id_in:[""],
        studios_id_in:[""],
        styles_id_eq:"",
        sort_emotion_id:"1",
      },
      page:1
    }
    it 'ステータス 200' do
      get '/api/v1/mains/search',params:params
      expect(response.status).to eq(200)
    end

    context 'emotion params が空の場合' do
      context 'pushArrayId.length==0'do 
        it '返却されるデーターに値が全て入っている' do
          get '/api/v1/mains/search',params:params
          expect(json['products'].size).to eq(10)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(10)
        end
      end

      context 'pushArrayId.length==1'do 
        it '返却されるデーターに値が全て入っている' do
          janl_id = Product.all[0].janls[0].id
          # style_id = Product.all[0].styles[0].id
          get '/api/v1/mains/search',params:{q: {
            janls_id_in:["","#{janl_id}"],
            casts_id_in:[""],
            studios_id_in:[""],
            styles_id_eq:"",
          },
          page:1}
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(1)
        end
      end

      context 'pushArrayId.length>1'do 
        it '返却されるデーターに値が全て入っている' do
          janl_id = Product.all[0].janls[0].id
          style_id = Product.all[0].styles[0].id
          get '/api/v1/mains/search',params:{q: {
            janls_id_in:["","#{janl_id}"],
            casts_id_in:[""],
            studios_id_in:[""],
            styles_id_eq:"#{style_id}",
          },
          page:1}
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(1)
        end
      end
    end

    context 'emotion params に値が存在する場合' do
      context 'pushArrayId.length==0'do 
        it '返却されるデーターに値が全て入っている' do
          get '/api/v1/mains/search',params:params2
          expect(json['products'].size).to eq(10)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(10)
        end
      end
      context 'pushArrayId.length==1'do 
        it '返却されるデーターに値が全て入っている' do
          janl_id = Product.all[0].janls[0].id
          # style_id = Product.all[0].styles[0].id
          get '/api/v1/mains/search',params:{q: {
            janls_id_in:["","#{janl_id}"],
            casts_id_in:[""],
            studios_id_in:[""],
            styles_id_eq:"",
            sort_emotion_id:"1",
          },
          page:1}
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(1)
        end
      end

      context 'pushArrayId.length>1'do 
        it '返却されるデーターに値が全て入っている' do
          janl_id = Product.all[0].janls[0].id
          style_id = Product.all[0].styles[0].id
          get '/api/v1/mains/search',params:{q: {
            janls_id_in:["","#{janl_id}"],
            casts_id_in:[""],
            studios_id_in:[""],
            styles_id_eq:"#{style_id}",
            sort_emotion_id:"1",
          },
          page:1}
          expect(json['products'].size).to eq(1)
          expect(json['products'][0]['product_styles'].size).to eq(1)
          expect(json['products'][0]['product_genres'].size).to eq(1)
          expect(json['products'][0]['product_year_season2'].size).to eq(2)
          expect(json['products_pages'].size).to eq(1)
          expect(json['scores']['avgScore'].size).to eq(1)
        end
      end


    end

  end
end

# {"q"=>{"title_cont"=>"", "janls_id_in"=>[""], "styles_id_eq"=>"", "s"=>"acsess_count desc", "casts_id_in"=>[""], "delivery_end_gteq"=>"", "delivery_start_gteq"=>"", "pickup_true"=>"", "finished"=>"", "new_content"=>"", "todays"=>"", "time_gteq"=>"", "time_lteq"=>"", "year_season_years_year_gteq"=>"", "year_season_years_year_lteq"=>"", "season_gteq"=>"", "season_lteq"=>"", "periodnumber"=>"1", "selectnumber"=>"0", "studios_id_in"=>[""], "year_season_seasons_id_eq"=>"", "sort_emotion_id"=>""}}