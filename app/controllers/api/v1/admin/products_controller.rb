class Api::V1::Admin::ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result(distinct: true).includes(:styles,:janls,:scores).year_season_scope.with_attached_bg_images.page(params[:page]).per(50)
    render :index,formats: :json
  end

  def setup
    @years = Year.all
    @seasons = Kisetsu.all
    render json:{years:@years}
  end

  def published
    @year = Year.find(params[:year])
    @season = Kisetsu.find(params[:season])
    @products = Product.joins(:year_season_products).where(year_season_products:{year_id:@year.id}).where(year_season_products:{kisetsu_id:@season.id})
    @products.each do |i|
      i.update( finished:params[:number] ) 
    end
  end

  def published_one
    @product = Product.find(params[:id])
    @product.update( finished:params[:number] )
    render json:{message:"#{@product.title}がアップデートされました。",product:@product}
  end
end