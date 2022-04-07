json.set! :products do
  json.array! @new_netflix do |product|
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
    # json.scores do
    #   json.array! product.scores
    # end
  end
end

json.set! :currentSeason, @current_season

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
    json.arasuzi a.description
    json.list a.list
    json.title a.title
  end
end

json.set! :tierAverage do
  json.tierAvg @tier
end


json.set! :scores do
  json.avgScore @scores
end