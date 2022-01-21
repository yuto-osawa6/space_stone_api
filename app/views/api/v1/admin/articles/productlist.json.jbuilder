json.set! :products do 
  json.array! @products do |product|
    json.value product.id
    json.label product.title
  end
end
