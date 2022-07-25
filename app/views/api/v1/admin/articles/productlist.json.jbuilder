json.set! :products do 
  json.array! @products do |product|
    json.value product.id
    json.label product.title
  end
end

json.set! :hashes do 
  json.array! @hash do |hash|
    json.value hash.id
    json.label hash.name
  end
end

