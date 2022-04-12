json.set! :worldRanking do
  json.array! @worldclass do |product|
    json.id product.id
    json.title product.title
    json.imageUrl product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.productStyles do
      json.array! product.styles
    end
    json.productGenres do
      json.array! product.janls
    end
    if product.delivery_start?
      if Date.today < product.delivery_start
        json.deliveryStart product.delivery_start
      end
    end

    json.productYearSeason2 do
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
