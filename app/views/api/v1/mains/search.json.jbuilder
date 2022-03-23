

json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.product_year_season2 do
      json.array! product.year_season_products do |a|
        json.id a.id
        json.year a.year
        json.season a.kisetsu
      end
    end 
    # json.scores do
    #   json.array! product.scores
    #   # .average(:value).round(1)
    # end

  end
end



json.set! :products_pages do
  json.page @products.total_pages
end 

json.set! :scores do
  json.avgScore @scores
end