# json.set! :message, "Hello world!v2"
# json.set! :status, 200
json.set! :length do
  json.length @length
end

json.set! :products do 
  json.array! @products do |product|
  json.id  product.id
  json.title  product.title
  json.image_url product.image_url
  json.arasuzi product.description
  # doneyet どっちか速度の問題
  json.your_score product.scores.where(scores:{user_id:@user.id})[0].value
  end
  # json.your_score Score.where(product_id:product,user_id:@user.id)[0].value

  # 追加
  # json.average_score @average_score
  # json.like_count @like_count
  # # json.products_style product.styles.name
  # json.product_styles do
  #   json.array! @product.styles
  # end
  # json.product_genres do
  #   json.array! @product.janls
  # end
  # json.product_reviews do
  #   json.array! @product.reviews.limit(4)
  # end
  # json.product_thereds do
  #   json.array! @product.thereds.limit(4)
  # end
  # json.questions do 
  #   json.array! @quesion
  # end
  # json.episords do
  #   json.array! @product.episords
  # end
end
# json.set! :liked do
# json.liked @liked
# json.like @like
# end

# json.set! :scored do
#   json.scored @scored
#   json.score @score
#   end
# json.set! :stats do
#   json.stats @stats_array
# end
# json.set! :acsesses do 
#   json.acsess_array @acsesses_array
#   json.month_array @month_array
# end
