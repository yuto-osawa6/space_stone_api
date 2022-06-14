json.key_format! camelize: :lower
json.set! :status,200

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
  json.questions @review.questions

  json.user_like_review @user_like_review
  json.like_review_length @review_length
  json.like_review_good @review_good
  json.score @score

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