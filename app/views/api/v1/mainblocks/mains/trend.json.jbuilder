json.set! :products do
  json.array! @trend do |product|
    json.id product.id
    json.title product.title
    json.imageUrl product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    # json.year product.year
    # json.duration  product.duration 
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

# json.set! :currentSeason, @current_season

json.set! :scores do
  json.avgScore @scores
end