json.set! :status,200
json.set! :user do
  json.id @user.id
  json.nickname @user.nickname
  json.image @user.topimage_url
  json.overview @user.overview
  json.background_image @user.image_url
  json.likeProducts do
    json.array! @like
  end
 
  json.likeGenres do
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
      json.product do
        json.id a.product.id
        json.image_url a.product.bgimage_url
      end
      json.user_id a.user_id
      json.aliceT a.tier_group_id
    end
  end
  

end