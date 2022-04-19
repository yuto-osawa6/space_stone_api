require 'rails_helper'

RSpec.describe 'Acsesses/acsess_articles', type: :request do
  describe 'POST /create' do
    let!(:admin_user) {create(:user)}
    let!(:article) {create_list(:article,2,weekormonth:1,user:User.first)}
    subject { post '/api/v1/acsesses/acsess_articles',params:{article_id:Article.first.id,date:Time.current,acsess_article:{article_id:Article.first.id,date:Time.current}}}
    it 'ステータス 200' do
      subject
      expect(json['status']).to eq(200)
    end
  end
end