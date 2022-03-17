# json.set! :product do 
#   json.id @product.id
#   json.title @product.title
#   json.image_url @product.image_url
# end

# json.set! :review do 
#   json.id @review.id
#   json.title @review.title
#   json.content @review.content
#   json.user_id @review.user_id
# end
# json.set! :review_comments do
#   json.array!  @review_comments do |comment|
#     json.id comment.id
#     json.comment comment.comment
    
#   end
# end

json.set! :product do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.bgimage_url
end

json.set! :review do 
  json.id @review.id
  json.title @review.title
  json.content @review.content
  json.user_id @review.user_id
  json.like_reviews @review.like_threads
  json.user @review.user
  json.updated_at @review.updated_at.strftime("%Y/%-m/%-d")

end
json.set! :review_comments do
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.updated_at comment.updated_at.strftime("%Y/%-m/%-d")

    json.like_comment comment.like_comment_threads
    # json.return_comment comment.return_comment_reviews
    json.return_jugde comment.return_comment_threads.present?

    json.user comment.user


    
  end
end