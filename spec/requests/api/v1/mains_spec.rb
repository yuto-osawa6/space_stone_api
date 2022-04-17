require 'rails_helper'
# binding.pry

RSpec.describe 'Main/Search', type: :request do
  describe 'GET /search' do
    # let!(:product_left) {create_list(:product_left,10)}
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
    # subject { post '/social_auth/callback',params:params }
    it 'ステータス 200' do
      get '/api/v1/mains/search',params:params
      # subject
      binding.pry
      expect(json['status']).to eq(200)
    end

    
  end
end

# {"q"=>{"title_cont"=>"", "janls_id_in"=>[""], "styles_id_eq"=>"", "s"=>"acsess_count desc", "casts_id_in"=>[""], "delivery_end_gteq"=>"", "delivery_start_gteq"=>"", "pickup_true"=>"", "finished"=>"", "new_content"=>"", "todays"=>"", "time_gteq"=>"", "time_lteq"=>"", "year_season_years_year_gteq"=>"", "year_season_years_year_lteq"=>"", "season_gteq"=>"", "season_lteq"=>"", "periodnumber"=>"1", "selectnumber"=>"0", "studios_id_in"=>[""], "year_season_seasons_id_eq"=>"", "sort_emotion_id"=>""}}