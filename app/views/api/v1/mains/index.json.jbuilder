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
    # json.title product.title
    # json.image_url product.image_url
    # json.arasuzi product.description
  end
end