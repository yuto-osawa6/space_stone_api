json.set! :reviews do
  # puts @Articles 
  
  json.array! @popular_reviews  do |review|
    json.id review.id
    json.title review.title
    json.content review.content
    # if ArticleProduct.exists?(article_id:article.id)
      # json.review_product do
    # json.reviewProduct review.product
    json.reviewProduct do
      json.id review.product.id
      json.image_url review.product.bg_images
      json.title review.product.title
    end
    

    json.reviewUser review.user
      # end
    # end
  end
end

json.set! :threads do
  # puts @Articles 
  
  json.array!  @popular_threads do |review|
    json.id review.id
    json.title review.title
    json.content review.content
    # if ArticleProduct.exists?(article_id:article.id)
      # json.review_product do
    json.reviewProduct do
      json.id review.product.id
      json.image_url review.product.bgimage_url
      json.title review.product.title
    end
    json.reviewUser review.user
      # end
    # end
  end
end
