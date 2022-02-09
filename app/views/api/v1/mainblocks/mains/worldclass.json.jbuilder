json.set! :world_ranking do
  json.array! @topten do |product|
    json.id product.product.id
    # json.title product.title
    json.image_url product.product.image_url
    json.title  product.product.title
    json.arasuzi product.product.description
    json.duration product.product.duration
    json.year product.product.year
    json.list product.product.list
    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    json.product_styles do
      json.array! product.product.styles
    end
    json.product_genres do
      json.array! product.product.janls
    end
    json.pickup product.product.pickup
    json.scores do
      json.array! product.product.scores
      # .average(:value).round(1)
    end
  end
end