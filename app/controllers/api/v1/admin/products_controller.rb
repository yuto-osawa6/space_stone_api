class Api::V1::Admin::ProductsController < ApplicationController
  def index
    # @years = Year.all
    # @seasons = Kisetsu.all

    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:styles,:janls,:scores).page(params[:page]).per(50)
    render :index,formats: :json
  end

  def setup
    @years = Year.all
    @seasons = Kisetsu.all
    render json:{years:@years}
  end

  def published
    puts params[:year]
    puts params[:season]

    @year = Year.find(params[:year])
    @season = Kisetsu.find(params[:season])
    puts @products = Product.joins(:year_season_products).where(year_season_products:{year_id:@year.id}).where(year_season_products:{kisetsu_id:@season.id})
    @products.each do |i|
      i.update( finished:params[:number] ) 
      # i.finished == params[:number]
    end

  end
end