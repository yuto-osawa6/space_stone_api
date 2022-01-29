json.set! :articles do
  # puts @Articles 
  
  json.array! @articles do |article|
    json.id article.id
    json.title article.title
    json.content article.content
    # if ArticleProduct.exists?(article_id:article.id)
      json.article_products do
        json.array! article.products
      end
    # end
  end
end