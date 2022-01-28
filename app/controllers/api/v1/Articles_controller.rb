class Api::V1::ArticlesController < ApplicationController
    def index
      # doneyet n+1 include
      if params[:weekormonth].present?
        @Articles = Article.where(weekormonth:params[:weekormonth]).page(params[:page]).per(2).order(created_at:"desc")
        @Article_length = Article.where(weekormonth:params[:weekormonth]).count
      else
        @Article_length = Article.count
        @Articles = Article.page(params[:page]).per(2).order(created_at:"desc")
      end
      puts @Articles
      render :index, formats: :json
    end

    def show
      puts params[:id]
    end

    def associate
      @product = Product.find(params[:product_id])
      render :associate,formats: :json
    end
end
