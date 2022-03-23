json.set! :world_ranking do
  json.array! @worldclass do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    if product.delivery_start?
      if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      end
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

json.set! :scores do
  json.avgScore2 @scores
end
