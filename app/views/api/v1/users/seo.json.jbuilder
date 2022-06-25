json.set! :status,200
json.set! :user do
  json.id @user.id
  json.nickname @user.nickname
  json.image @user.topimage_url
  json.overview @user.overview
  json.background_image @user.image_url
end