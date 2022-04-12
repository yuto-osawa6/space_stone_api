json.set! :products do
  json.array! @pickup do |product|
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

    json.productYearSeason2 do
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
    json.imageUrl product.bgimage_url
    json.arasuzi product.description
    json.list product.list

    json.productStyles do
      json.array! product.styles
    end
    json.productGenres do
      json.array! product.janls
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

json.set! :currentSeason, @current_season
json.set! :currentSeason2, @current_season2


json.set! :tier do
  json.array! @tier_p do |a|
    json.id a.id
    json.image_url a.bgimage_url
    json.arasuzi a.description
    json.list a.list
    json.title a.title
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
