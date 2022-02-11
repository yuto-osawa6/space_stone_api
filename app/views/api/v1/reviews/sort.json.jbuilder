# json.set! :product do 
#   json.id @product.id
#   json.title @product.title
#   json.image_url @product.image_url

# end
# json.set! :liked do
# json.liked @liked
# json.like @like
# end
# json.set! :review do 
#   json.id @review.id
#   json.title @review.title
#   # json.discribe @review.discribe
#   json.content @review.content
#   json.user_id @review.user_id
#   # json.product_id @review.created_at

#   # json.user_name @review.user.email
# end

# json.set! :review_comments do
#   # json.goodbad  @review_comments
#   json.array!  @review_comments do |comment|
#     json.id comment.id
#     json.comment comment.comment
    
#   end
# end

# v1.01ーーーーーーーーーーーーーーーーーーーーーー

json.set! :review_comments do
  # json.goodbad  @review_comments
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.like_comment comment.like_comment_reviews
    # json.return_comment comment.return_comment_reviews
    json.return_jugde comment.return_comment_reviews.present?
    
  end
end