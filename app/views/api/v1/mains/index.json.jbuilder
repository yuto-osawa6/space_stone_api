# json.set! :products do 
#   json.array! @products do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     # # json.products_style product.styles.name
#     # json.product_styles do
#     #   json.array! product.styles
#     # end
#     # json.product_genres do
#     #   json.array! product.janls
#     # end
#   end
# end

json.set! :mains do
  json.array! @new_netflix do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end

end

json.set! :decision_news do
  json.array! @decision_news do |news|
    json.id news.id
    json.title news.title
    json.description news.description
    json.judge news.judge
    json.date news.updated_at.strftime("%-m/%-d")
    # json.title product.title
    # json.image_url product.image_url
    # json.arasuzi product.description
  end
end

json.set! :pickup do
  json.array! @pickup do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end

json.set! :delivery_end do
  json.array! @delivery_end do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.delivery_end product.delivery_end
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end


json.set! :delivery_start do
  json.array! @delivery_start do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end



json.set! :world_ranking do
  json.array! @topten do |product|
    json.id product.product.id
    # json.title product.title
    json.image_url product.image_url
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
  end
end