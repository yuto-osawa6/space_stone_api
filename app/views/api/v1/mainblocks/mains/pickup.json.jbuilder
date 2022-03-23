json.set! :products do
  json.array! @pickup do |product|
    json.id product.id
    json.title product.title
    # json.image_url product.image_url
    json.image_url product.bgimage_url
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

    json.product_year_season2 do
      json.array! product.year_season_products do |a|
        json.id a.id
        json.year a.year
        json.season a.kisetsu
      end
    end 

  end

end

json.set! :products2 do
  json.array! @pickup2 do |product|
    json.id product.id
    json.title product.title
    # json.image_url product.image_url
    json.image_url product.bgimage_url
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

    json.product_year_season2 do
      json.array! product.year_season_products do |a|
        json.id a.id
        json.year a.year
        json.season a.kisetsu
      end
    end 

  end

end

json.set! :current_season, @current_season
json.set! :current_season2, @current_season2


json.set! :tier do
  json.array! @tier_p do |a|
    json.id a.id
    json.image_url a.bgimage_url
  end
end

json.set! :tier_average do
  json.tierAvg @tier
end

json.set! :scores do
  json.avgScore @scores
end

json.set! :scores do
  json.avgScore2 @scores2
end
