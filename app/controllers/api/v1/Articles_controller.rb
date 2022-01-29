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
      @article = Article.find(params[:article_id])
      render :show, formats: :json
    end

    def associate
      @product = Product.find(params[:product_id])
      render :associate,formats: :json
    end

    def article_associate
      article = ArticleProduct.where(article_id:params[:article_id]).pluck(:product_id)
      puts article
      @articles = Article.joins(:article_products).where(article_products: { product_id: article }).group(:article_id).order("count(article_id) desc").limit(6)
      # product_ids = article.group(:product_id).plunk(:product_id)
      render :article_associate,formats: :json
    end
end
