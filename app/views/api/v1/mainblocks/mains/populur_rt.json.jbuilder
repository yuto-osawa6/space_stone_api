json.set! :reviews do
  json.array! @popular_reviews  do |review|
    json.id review.id
    json.title review.title
    json.content review.content
    json.reviewProduct do
      json.id review.product.id
      json.image_url review.product.bgimage_url
      json.title review.product.title
    end
    json.reviewUser review.user
  end
end

json.set! :threads do  
  json.array!  @popular_threads do |review|
    json.id review.id
    json.title review.title
    json.content review.content
    json.reviewProduct do
      json.id review.product.id
      json.image_url review.product.bgimage_url
      json.title review.product.title
    end
    json.reviewUser review.user
  end
end
