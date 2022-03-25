# render json:{product: @product,length: @length}

json.set! :product do
  json.array! @product do |product|
    json.id product.id
    json.title  product.title
    json.image_url product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
  end
end

json.set! :length,@length

# json.id product.id
#     json.title product.title
#     json.image_url product.bgimage_url
#     json.arasuzi product.description
#     json.list product.list
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end