json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    json.list product.list
    json.finished product.finished
    # json.a product.id

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    json.pickup product.pickup
    json.scores do
      json.array! product.scores
    end
  end

end

# json.set! :Kisetsu do

# end

# json.set! :Year


# json.set! :products_pages do
#   json.page @products.total_pages
# end 