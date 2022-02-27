json.set! :message, "Hello world!v2"
json.set! :status, 200


json.set! :products do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.image_url
  json.arasuzi @product.description
  json.list @product.list
  if @episord.present?
    json.product_episord do
      json.arasuzi @episord[0].arasuzi
      json.episord @episord[0].episord
      json.release_date @episord[0].release_date
    end
  end
  # 追加
  json.average_score @average_score
  json.like_count @like_count
  # # json.products_style product.styles.name
  json.product_styles do
    json.array! @product.styles
  end
  json.product_genres do
    json.array! @product.janls
  end
  json.product_reviews do
    json.array! @product.reviews
  end
  json.product_thereds do
    json.array! @product.thereds
  end
  json.questions do 
    json.array! @quesion
  end
  json.episords do
    json.array! @product.episords
  end
  # 2.0
  json.product_studio do
    json.array! @product.studios
  end
  json.product_character do
    json.array! @character do |c|
      json.id c.id
      json.name c.name
      json.cast_name c.cast
    end
  end 
  json.product_staff do
    json.array! @staff do |c|
      json.id c.id
      json.name c.name
      json.staff_name c.staff
    end
  end

  json.product_yearSeason do
    json.array! @yearSeason do |ys|
      json.year ys.year
      json.season ys.year_season_seasons
    end
  end

end





json.set! :liked do
json.liked @liked
json.like @like
end

json.set! :scored do
  json.scored @scored
  json.score @score
  end
json.set! :stats do
  json.stats @stats_array
end
json.set! :acsesses do 
  json.acsess_array @acsesses_array
  json.month_array @month_array
end

# json.set! :questions do 
#   json.array! @quesion
# end