class Api::V1::ArticlesController < ApplicationController
  def index
    # notest-s
    if params[:product_id].present?
      if params[:weekormonth].present?
        article = Product.find(params[:product_id])
        @Articles = Article.where(weekormonth:params[:weekormonth]).left_outer_joins(:products).includes(products: :janls).includes(products: :styles).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")
        @Article_length = Article.where(weekormonth:params[:weekormonth]).joins(:article_products).where(article_products: { product_id: article.id }).length
      else
        article = Product.find(params[:product_id])
        @Article_length = Article.joins(:article_products).where(article_products: { product_id: article.id }).length
        @Articles = Article.left_outer_joins(:products).includes(:products).includes(products: :janls).includes(products: :styles).where(article_products: { product_id: article.id }).page(params[:page]).per(2).order(created_at:"desc")
      end
    else
      if params[:weekormonth].present?
        @Articles = Article.includes(:products).where(weekormonth:params[:weekormonth]).page(params[:page]).per(2).order(created_at:"desc")
        @Article_length = Article.where(weekormonth:params[:weekormonth]).length
      else
        @Article_length = Article.count
        @Articles = Article.includes(:products).includes(products: :janls).includes(products: :styles).page(params[:page]).per(2).order(created_at:"desc")
      end
    end
    render :index, formats: :json
  end

  def show
    @article = Article.includes(:products).includes(products: :janls).includes(products: :styles).find(params[:article_id])
    render :show, formats: :json
  end

  # def associate
  #   @product = Product.includes(:styles,:janls).find(params[:product_id])
  #   render :associate,formats: :json
  # end

  def article_associate
    article = ArticleProduct.where(article_id:params[:article_id]).pluck(:product_id)
    @articles = Article.where.not(id:params[:article_id]).includes(products: :janls).includes(products: :styles).left_outer_joins(:products).includes(:products).where(article_products: { product_id: article }).group(:article_id).order("count(article_id) desc").limit(6)
    render :article_associate,formats: :json
  end
end
