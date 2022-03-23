# json.set! :message, "Hello world!v2"
# json.set! :status, 200
json.set! :length do
  json.length @length
end

json.set! :products do 
  json.array! @products do |product|
    json.id  product.id
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

json.set! :your_socres,@your_score