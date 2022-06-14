json.set! :is_login ,true
json.set! :data do
json.id current_user.id
json.nickname current_user.nickname
json.administrator_gold current_user.administrator_gold 
json.backgroundImage current_user.image_url
json.image current_user.topimage_url
json.overview current_user.overview
# json.background_image current_user.image_url
json.provider current_user.provider
end