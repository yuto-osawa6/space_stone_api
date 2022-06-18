json.set! :message, "Hello world!v2"
json.set! :status, 200


json.set! :products do 
  json.id @product.id
  json.title @product.title
  # json.image_url @product.image_url
  json.imageUrl @product.bgimage_url
  json.arasuzi @product.description
  json.list @product.list
  json.overview @product.overview
  json.annict @product.annitict
  json.shoboi @product.shoboiTid

  if @episord.present?
    json.productEpisord do
      json.arasuzi @episord[0].arasuzi
      json.episord @episord[0].episord
      json.release_date @episord[0].release_date
    end
  end
  # 追加
  json.averageScore @average_score
  json.likeCount @like_count
  # # json.products_style product.styles.name
  json.productStyles do
    json.array! @product.styles
  end
  json.productGenres do
    json.array! @product.janls
  end
  # json.product_reviews do
  #   json.array! @product.reviews
  # end
  # json.product_thereds do
  #   json.array! @product.thereds
  # end
  json.questions do 
    json.array! @quesion
  end
  json.episords do
    json.array! @product.episords
  end
  # 2.0
  json.productStudio do
    json.array! @product.studios
  end
  json.productCharacter do
    json.array! @character do |c|
      json.id c.id
      json.name c.name
      json.castName c.cast
    end
  end 
  json.productStaff do
    json.array! @staff do |c|
      json.id c.id
      json.name c.name
      json.staffName c.staff
    end
  end

  json.productYearSeason do
    json.array! @yearSeason do |ys|
      json.year ys.year
      # doneyet-1 n+1発生
      json.season ys.year_season_seasons.where(year_season_products:{product_id:@product.id})
    end
  end

  json.userReviews do
    json.array! @userEpisord do |ue|
      json.id ue.id
      json.content ue.content
      json.episordId ue.episord_id
      json.emotions ue.emotions
    end
  end

  json.emotions do
    json.array! @emotions do |e|
      json.id e.id
      json.emotion e.emotion
    end
  end

end

json.set! :productReviews do
  json.array! @product.reviews
end
json.set! :productThreads do
  json.array! @product.thereds
end

json.set! :EmotionLists do
  json.array! @emotionList.zip(@emotionList.count) do |el,k|
    json.id el.id
    json.emotion el.emotion
    json.length k[1]
  end
end

json.set! :productScores do
  json.array! @product.scores
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
  json.acsessArray @acsesses_array
  json.monthArray @month_array
end

# json.set! :questions do 
#   json.array! @quesion
# end