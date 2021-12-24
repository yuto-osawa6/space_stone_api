json.set! :message, "Hello world!v2"
json.set! :status, 200


json.set! :products do 
  json.id @product.id
  json.title @product.title
  json.image_url @product.image_url
  json.arasuzi @product.description
  # # json.products_style product.styles.name
  json.product_styles do
    json.array! @product.styles
  end
  json.product_genres do
    json.array! @product.janls
  end
end
json.set! :liked do
json.liked @liked
json.like @like
end

json.set! :scored do
  json.scored @scored
  json.score @score
  end
