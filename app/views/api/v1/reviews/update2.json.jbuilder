# json.set! :userReview do
#   # json.userReviews do
#     json.array! @userReview do |ue|
#       json.id ue.id
#       json.content ue.content
#       json.episord_id ue.episord_id
#       json.emotions ue.emotions
#     end
#   end
  
#   json.set! :productReviews do
#     json.array! @product.reviews
#   end
#   # json.set! :productThreads do
#   #   json.array! @product.thereds
#   # end
  
#   json.set! :emotionLists do
#     json.array! @emotionList.zip(@emotionList.count) do |el,k|
#       json.id el.id
#       json.emotion el.emotion
#       json.length k[1]
#     end
#   end

  json.set! :review do 
    json.id @review.id
    json.title @review.title
    json.content @review.content
    json.user_id @review.user_id
    json.like_reviews @review.like_reviews
    json.user @review.user
    json.updated_at @review.updated_at.strftime("%Y/%-m/%-d")
    json.review_emotions @review.emotions
    json.episord_id @review.episord_id
  
  end