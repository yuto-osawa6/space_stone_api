json.set! :genres do 
  json.array! @genres do |genre|
    json.id genre.id
    json.name genre.name
    # json.image_url product.image_url
    # json.arasuzi product.description
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end