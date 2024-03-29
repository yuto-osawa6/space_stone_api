json.set! :status,200
json.set! :message do
  json.title "「#{@product.title}」のレビューを作成しました。"
  json.select 1
end

json.set! :userReview do
  # json.userReviews do
    json.array! @userReview do |ue|
      json.id ue.id
      json.content ue.content
      json.episord_id ue.episord_id
      json.emotions ue.emotions
      json.score ue.score
    end
  end

  json.set! :productReviews do
    json.array! @productReviews
  end
  # json.set! :productThreads do
  #   json.array! @product.thereds
  # end
  
  json.set! :emotionLists do
    json.array! @emotionList.zip(@emotionList.count) do |el,k|
      json.id el.id
      json.emotion el.emotion
      json.length k[1]
    end
  end