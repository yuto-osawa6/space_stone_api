

json.set! :status, 200


json.set! :products do 
  json.id @product.id
  json.title @product.title
  # json.image_url @product.image_url
  json.imageUrl @product.bgimage_url
  json.arasuzi @product.description
  json.list @product.list
  json.overview @product.overview
end