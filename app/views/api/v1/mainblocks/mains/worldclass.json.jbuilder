# json.set! :world_ranking do
#   json.array! @topten do |product|
#     json.id product.product.id
#     # json.title product.title
#     json.image_url product.product.image_url
#     json.title  product.product.title
#     json.arasuzi product.product.description
#     json.duration product.product.duration
#     json.year product.product.year
#     json.list product.product.list
#     # json.arasuzi product.description
#     # json.delivery_start product.delivery_start
#     # # json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.product.styles
#     end
#     json.product_genres do
#       json.array! product.product.janls
#     end
#     json.pickup product.product.pickup
#     json.scores do
#       json.array! product.product.scores
#       # .average(:value).round(1)
#     end
#   end
# end

json.set! :world_ranking do
  json.array! @worldclass do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    json.list product.list
    # json.season product.season
    # json.products_style product.styles.name
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    # if product.delivery_end?
    #   if Date.today < product.delivery_end
    #     json.delivery_end product.delivery_end
    #   end
    # end
    if product.delivery_start?
      if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      end
    end
    # json.pickup product.pickup
    # doneyet_1_priority (lengthの変更)
    # if product.scores.exists?
      # &&product.scores.length>0
    json.scores do
      json.array! product.scores
      # .average(:value).round(1)
    end

    # json.tags do
    #   json.array! product.tags
    # end
  end

end

# json.set! :current_season, @current_season