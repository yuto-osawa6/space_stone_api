json.set! :user do
  json.id @user.id
  json.nickname @user.nickname
  json.image @user.image
  json.overview @user.overview
  json.background_image @user.image_url
  json.likeProducts do
    json.array! @like
  end
  # json.scoreProducts do
  #   json.array! @user.scores_products
  # end

  # json.reviewProducts do
  #   # json.array! @user.reviews_products
  #   json.array! @user.reviews
  # end
  # json.threadProducts do
  #   # json.array! @user.thereds_products
  #   json.array! @user.thereds
  # end

  json.likeGenres do
    # json.array! @user.thereds_products
    json.array! @genre
  end

  json.emotions do
    json.array! @emotion
  end
  json.emotion_count @emotion_count
  json.emotion_all_count @emotion_all_count

  json.score_emotions do
    json.array! @score_emotion
  end
  json.score_emotion_count @score_emotion_count
  json.score_emotion_all_count @score_emotion_all_count

  json.score @score_array
  
  json.tier do
    json.array! @tier_group do |a|
      json.id a.id
      json.tier a.tier
      json.product a.product
      json.user_id a.user_id
    end
  end

end