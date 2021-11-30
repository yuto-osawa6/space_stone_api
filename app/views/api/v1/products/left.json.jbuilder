json.set! :genres do
  json.array! @genres do |category|
    json.id category.id
    json.name category.name
    json.count category.products.length
  end
end

json.set! :styles do
  json.array! @styles do |style|
    json.id style.id
    json.name style.name
    json.count style.products.length
  end
end