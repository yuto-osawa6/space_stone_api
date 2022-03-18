json.set! :product do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.bgimage_url
  json.arasuzi @product.description
  json.year @product.year
  json.duration @product.duration
  # json.average_score @average_score
  # json.like_count @like_count
  # # json.products_style product.styles.name
  json.product_styles do
    json.array! @product.styles
  end
  json.product_genres do
    json.array! @product.janls
  end
  # json.product_reviews do
  #   json.array! @product.reviews.limit(4)
  # end
  # json.product_thereds do
  #   json.array! @product.thereds.limit(4)
  # end
  # json.questions do 
  #   json.array! @quesion
  # end
  # json.episords do
  #   json.array! @product.episords
  # end
end