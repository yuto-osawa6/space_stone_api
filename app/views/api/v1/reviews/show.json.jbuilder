json.set! :product do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.image_url
  # json.arasuzi @product.description
  # 追加
  # json.average_score @average_score
  # json.like_count @like_count

  # json.product_styles do
  #   json.array! @product.styles
  # end
  # json.product_genres do
  #   json.array! @product.janls
  # end
  # json.product_reviews do
  #   json.array! @product.reviews.limit(4)
  # end
  # json.product_thereds do
  #   json.array! @product.thereds.limit(4)
  # end
  # json.questions do 
  #   json.array! @quesion
  # end
end
# json.set! :liked do
# json.liked @liked
# json.like @like
# end
json.set! :review do 
  json.id @review.id
  json.title @review.title
  # json.discribe @review.discribe
  json.content @review.content
  json.user_id @review.user_id
  # json.product_id @review.created_at

  # json.user_name @review.user.email
end
json.set! :review_comments do
  # json.goodbad  @review_comments
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    
  end
end