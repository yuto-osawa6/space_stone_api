# render json:{product: @product,length: @length}

json.set! :product do
  json.array! @product do |a|
  json.id a.id
  json.image_url a.bgimage_url
  end
end

json.set! :length,@length