# json.set! :status,200

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
    json.aliceT a.tier_group_id
  end
end

json.set! :current_season, @current_season

json.set! :products do
  json.array! @new_netflix do |product|
  json.id product.id
  json.title product.title
  json.imageUrl product.bgimage_url
  json.arasuzi product.description
  json.list product.list
  end
end
