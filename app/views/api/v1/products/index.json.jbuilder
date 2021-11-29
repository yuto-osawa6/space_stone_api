# json.set! :message do
#   json.message 200
# end
json.set! :message, "Hello world!v2"
json.set! :status, 200


json.set! :products do 
  json.array! @products do |product|
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

json.set! :genres do
  json.array! @genres do |category|
    json.id category.id
    json.name category.name
  end
end

json.set! :styles do
  json.array! @styles do |style|
    json.id style.id
    json.name style.name
    json.count style.products.length
  end
end