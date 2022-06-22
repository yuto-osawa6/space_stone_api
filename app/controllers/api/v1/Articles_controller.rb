class Api::V1::ArticlesController < ApplicationController
  def index
    # notest-s
    if params[:product_id].present?
      if params[:weekormonth].present?
        article = Product.find(params[:product_id])
        @Articles = Article.where(weekormonth:params[:weekormonth]).left_outer_joins(:products).includes(products: :janls).includes(products: :styles).where(article_products: { product_id: article.id }).page(params[:page]).per(Concerns::PAGE[:article]).order(created_at:"desc")
        @Article_length = Article.where(weekormonth:params[:weekormonth]).joins(:article_products).where(article_products: { product_id: article.id }).length
      else
        article = Product.find(params[:product_id])
        @Article_length = Article.joins(:article_products).where(article_products: { product_id: article.id }).length
        @Articles = Article.left_outer_joins(:products).includes(:products).includes(products: :janls).includes(products: :styles).where(article_products: { product_id: article.id }).page(params[:page]).per(Concerns::PAGE[:article]).order(created_at:"desc")
      end
    else
      if params[:weekormonth].present?
        @Articles = Article.includes(:products).where(weekormonth:params[:weekormonth]).page(params[:page]).per(Concerns::PAGE[:article]).order(created_at:"desc")
        @Article_length = Article.where(weekormonth:params[:weekormonth]).length
      else
        @Article_length = Article.count
        @Articles = Article.includes(:products).includes(products: :janls).includes(products: :styles).page(params[:page]).per(Concerns::PAGE[:article]).order(created_at:"desc")
      end
    end
    render :index, formats: :json
  end

  def show
    begin
    @article = Article.includes(:products).includes(:hashtags).includes(products: :janls).includes(products: :styles).find(params[:id])
    render :show, formats: :json
    rescue =>e
      puts e
      render json:{status:500}
    end
  end

  # def associate
  #   @product = Product.includes(:styles,:janls).find(params[:product_id])
  #   render :associate,formats: :json
  # end

  def article_associate
    article = ArticleProduct.where(article_id:params[:article_id]).pluck(:product_id)
    articles = Article.where.not(id:params[:article_id]).includes(:hashtags).includes(products: :janls).includes(products: :styles).left_outer_joins(:article_products).includes(:products).where(article_products: { product_id: article }).group("articles.id").order("count(article_products.article_id) desc").limit(6)
    hashtag = HashtagArticle.where(article_id:params[:article_id]).pluck(:hashtag_id)
    articles2 = Article.where.not(id:params[:article_id]).includes(:hashtags).includes(products: :janls).includes(products: :styles).left_outer_joins(:hashtag_articles).includes(:products).where(hashtag_articles: { hashtag_id: hashtag }).group("articles.id").order("count(hashtag_articles.article_id) desc").limit(6)
    add_articles = Article.where.not(id:params[:article_id]).where.not(id:articles.ids).includes(products: :janls).includes(products: :styles).order(created_at: :desc).limit(6-(articles.length))
    add_articles2 = Article.where.not(id:params[:article_id]).where.not(id:articles2.ids.push(add_articles.ids).flatten).includes(products: :janls).includes(products: :styles).order(created_at: :desc).limit(6-(articles2.length))
    @articles = articles + add_articles
    @articles2 = articles2 + add_articles2
    # @articles = add_articles + articles
    # @articles2 = add_articles2 +  articles2

    render :article_associate,formats: :json
  end
end
