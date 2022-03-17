class Api::V1::ArticlesController < ApplicationController
    def index
      # doneyet n+1 include
      puts params[:product_id].present?
      if params[:product_id].present?
        if params[:weekormonth].present?
          article = Product.find(params[:product_id])
          # @Articles = Article.where(weekormonth:params[:weekormonth]).joins(:article_products).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")
          @Articles = Article.where(weekormonth:params[:weekormonth]).left_outer_joins(:products).includes(:products).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")

          #doneyet edit 
          @Article_length = Article.where(weekormonth:params[:weekormonth]).joins(:article_products).where(article_products: { product_id: article.id }).length
        else
          article = Product.find(params[:product_id])
          @Article_length = Article.joins(:article_products).where(article_products: { product_id: article.id }).length
          # @Articles = Article.joins(:article_products).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")
          @Articles = Article.left_outer_joins(:products).includes(:products).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")
        end
      else
        if params[:weekormonth].present?
          @Articles = Article.includes(:products).where(weekormonth:params[:weekormonth]).page(params[:page]).per(2).order(created_at:"desc")
          @Article_length = Article.where(weekormonth:params[:weekormonth]).length
        else
          @Article_length = Article.count
          @Articles = Article.includes(:products).page(params[:page]).per(2).order(created_at:"desc")
        end
      end
      puts @Articles
      render :index, formats: :json
    end

    def show
      @article = Article.includes(:products).find(params[:article_id])
      render :show, formats: :json
    end

    def associate
      @product = Product.includes(:styles,:janls).find(params[:product_id])
      render :associate,formats: :json
    end

    def article_associate
      article = ArticleProduct.where(article_id:params[:article_id]).pluck(:product_id)
      puts article
      # @articles = Article.joins(:article_products).where(article_products: { product_id: article }).group(:article_id).order("count(article_id) desc").limit(6)
      @articles = Article.left_outer_joins(:products).includes(:products).where(article_products: { product_id: article }).group(:article_id).order("count(article_id) desc").limit(6)

      # product_ids = article.group(:product_id).plunk(:product_id)
      render :article_associate,formats: :json
    end

    # def product_search
    #   @products = Product.where("name LIKE ?", "%#{params[:product_title]}%")
    # end
end