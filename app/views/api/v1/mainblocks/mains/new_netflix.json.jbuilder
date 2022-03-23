json.set! :products do
  json.array! @new_netflix do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.arasuzi product.description
    # json.year product.year
    # json.duration  product.duration 
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    json.scores do
      json.array! product.scores
    end
  end
end

json.set! :current_season, @current_season

# tier
# json.set! :tier do
#   json.array! @tier do |tier|
#     json.id tier.id
#     json.tier tier.tier
#     json.user_id tier.user_id
#     json.product tier.product
#   end
# end

json.set! :tier do
  json.array! @tier_p do |a|
    json.id a.id
    json.image_url a.bgimage_url
  end
end

json.set! :tier_average do
  json.tierAvg @tier
end