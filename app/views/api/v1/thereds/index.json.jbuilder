json.set! :reviews do
  # puts @Articles 
  
  json.array! @reviews do |review|
    json.id review.id
    json.title review.title
    json.content review.content
    # if ArticleProduct.exists?(article_id:article.id)
      # json.review_product do
    json.reviewProduct do
      json.id review.product.id
      json.image_url review.product.bgimage_url
    end
    json.reviewUser review.user
      # end
    # end
  end
end
json.set! :review_length,@review_length
