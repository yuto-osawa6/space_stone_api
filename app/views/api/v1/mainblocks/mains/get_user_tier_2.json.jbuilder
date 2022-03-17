
json.set! :user_tier do
  json.array! @tier_group do |a|
    json.id a.id
    json.tier a.tier
    json.product do
      # json.array! a
      json.id a.product.id
      json.image_url a.product.bgimage_url
    end 
    # json.product a.product
    # json.user_id a.user_id
  end
 end
 
 json.set! :current_season, @current_season
 
 json.set! :products do
   json.array! @new_netflix do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    # if product.delivery_end?
    #   if Date.today < product.delivery_end
    #     json.delivery_end product.delivery_end
    #   end
    # end
    # if product.delivery_start?
    #   if Date.today < product.delivery_start
    #     json.delivery_start product.delivery_start
    #   end
    # end
    json.pickup product.pickup
    json.scores do
      json.array! product.scores
    end

    json.tags do
      json.array! product.tags
    end

   end
 end