json.key_format! camelize: :lower
json.set! :status,200

json.set! :product do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.bgimage_url
  # json.imageUrl @product.bgimage_url
end

json.set! :review do 
  json.id @review.id
  json.title @review.title
  json.content @review.content
  json.user_id @review.user_id
  json.episordScore @review.score
  json.episord @episord
  json.episordTitle @episordTitle
  # json.like_reviews @review.like_reviews
  # json.user @review.user
  json.updated_at @review.updated_at.strftime("%Y/%-m/%-d")
  json.review_emotions @review.emotions
  json.episord_id @review.episord_id
  json.user_like_review @user_like_review
  json.like_review_length @review_length
  json.like_review_good @review_good
  json.score @score
  json.user do
    json.id @review.user.id
    json.nickname @review.user.nickname
    json.image @review.user.topimage_url
  end 


end
json.set! :review_comments do
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.updated_at comment.updated_at.strftime("%Y/%-m/%-d")
    json.like_comment comment.like_comment_reviews
    json.return_jugde comment.return_comment_reviews.present?
    # json.user comment.user  
    json.user do
      json.id comment.user.id
      json.nickname comment.user.nickname
      json.image comment.user.topimage_url
    end 
    # json.updatedAt comment.updated_at.strftime("%Y/%-m/%-d")
    # json.likeComment comment.like_comment_reviews
    # json.returnJugde comment.return_comment_reviews.present? 
  end
end