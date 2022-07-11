json.set! :userReview do
  json.array! @userReview do |ue|
    json.id ue.id
    json.content ue.content
    json.episord_id ue.episord_id
    json.emotions ue.emotions
    json.score ue.score
  end
end

json.set! :productReviews do
  json.array! @product.reviews
end

json.set! :emotionLists do
  json.array! @emotionList.zip(@emotionList.count) do |el,k|
    json.id el.id
    json.emotion el.emotion
    json.length k[1]
  end
end