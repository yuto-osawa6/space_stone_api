class Api::V1::ArticlesController < ApplicationController
    def index
      if params[:weekormonth].present?
        @Articles = Article.where(weekormonth:params[:weekormonth]).page(params[:page]).per(5)
      else
        @Articles = Article.page(params[:page]).per(5)
      end
      # puts @Articles
      render :index, formats: :json
    end

    def show
      puts params[:id]
    end
end
