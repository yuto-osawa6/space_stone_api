json.set! :products do
  json.array! @pickup do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    # json.products_style product.styles.name
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    if product.delivery_end?
      if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      end
    end
    if product.delivery_start?
      if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      end
    end
    json.pickup product.pickup
    # doneyet_1_priority (lengthの変更)
    # if product.scores.exists?
      # &&product.scores.length>0
    json.scores do
      json.array! product.scores
      # .average(:value).round(1)
    end

    json.tags do
      json.array! product.tags
    end

  end

end

json.set! :products2 do
  json.array! @pickup2 do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    # json.products_style product.styles.name
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    if product.delivery_end?
      if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      end
    end
    if product.delivery_start?
      if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      end
    end
    json.pickup product.pickup
    # doneyet_1_priority (lengthの変更)
    # if product.scores.exists?
      # &&product.scores.length>0
    json.scores do
      json.array! product.scores
      # .average(:value).round(1)
    end

    json.tags do
      json.array! product.tags
    end

  end

end

json.set! :current_season, @current_season
json.set! :current_season2, @current_season2


json.set! :tier do
  json.array! @tier_p
end

json.set! :tier_average do
  json.tierAvg @tier
end