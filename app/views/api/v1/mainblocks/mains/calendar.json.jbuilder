json.set! :delivery_start do
  json.array! @delivery_start do |product|
    json.id product.id
    json.title product.title
    # json.image_url product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    # if product.delivery_end?
    #   if Date.today < product.delivery_end
    #     json.delivery_end product.delivery_end
    #   end
    # end
    # json.delivery_start product.delivery_start

  end

end

json.set! :episord_start do
  json.array! @episord do |episord|
    json.id episord.product.id
    json.title episord.product.title
    json.image_url episord.product.bgimage_url
    json.arasuzi episord.product.description
    json.year episord.product.year
    json.list episord.product.list
    json.product_styles do
      json.array! episord.product.styles
    end
    json.product_genres do
      json.array! episord.product.janls
    end
  
    # json.delivery_start episord.product.delivery_start
    json.delivery_start episord.release_date

    json.product_episord do
    json.arasuzi episord.arasuzi
    json.episord episord.episord
    json.release_date episord.release_date
    end

    json.product_year_season2 do
      json.array! episord.product.year_season_products do |a|
        json.id a.id
        json.year a.year
        json.season a.kisetsu
      end
    end 

  end
end

json.set! :scores do
  json.avgScore @scores
end

