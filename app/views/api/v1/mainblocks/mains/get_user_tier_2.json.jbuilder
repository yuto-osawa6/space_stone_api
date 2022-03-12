
json.set! :user_tier do
  json.array! @tier_group do |a|
    json.id a.id
    json.tier a.tier
    json.product a.product
    json.user_id a.user_id
  end
 end
 
 json.set! :current_season, @current_season
 
 json.set! :products do
   json.array! @new_netflix
 end