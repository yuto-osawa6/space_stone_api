json.set! :status,200

json.set! :user_tier do
 json.array! @tier_group do |a|
   json.id a.id
   json.tier a.tier
   json.product do 
    json.id a.product.id
    json.image_url a.product.bgimage_url
    json.arasuzi a.product.description
    json.list a.product.list
    json.title a.product.title
   end
   json.user_id a.user_id
 end
end

json.set! :current_season, @current_season

# json.set! :products do
#   # doneyet-1これが何か不明
#   # userpageで必要な情報だった。
#   # json.array! @new_netflix
# end