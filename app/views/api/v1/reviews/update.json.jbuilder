json.set! :userReview do
# json.userReviews do
  json.array! @userReview do |ue|
    json.id ue.id
    json.content ue.content
    json.episord_id ue.episord_id
    json.emotions ue.emotions
  end
end