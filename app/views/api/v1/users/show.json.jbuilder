json.set! :user do
  json.id @user.id
  json.nickname @user.nickname
  json.image @user.image
  json.overview @user.overview
  json.background_image @user.image_url
  json.likeProducts do
    json.array! @user.liked_products
  end
  json.scoreProducts do
    json.array! @user.scores_products
  end

  json.reviewProducts do
    # json.array! @user.reviews_products
    json.array! @user.reviews
  end
  json.threadProducts do
    # json.array! @user.thereds_products
    json.array! @user.thereds
  end
end