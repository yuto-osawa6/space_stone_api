json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
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
    json.product_year_season2 do
      json.array! product.year_season_products do |a|
        json.id a.id
        json.year a.year
        json.season a.kisetsu
      end
    end 
  end

end

# json.set! :Kisetsu do

# end

# json.set! :Year


# json.set! :products_pages do
#   json.page @products.total_pages
# end 