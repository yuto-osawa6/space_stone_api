json.set! :deliveryStart do
  json.array! @delivery_start do |product|
    json.id product.id
    json.title product.title
    # json.image_url product.bgimage_url
    json.arasuzi product.description
    json.list product.list
    json.productStyles do
      json.array! product.styles
    end
    json.productGenres do
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

json.set! :episordStart do
  json.array! @episord do |episord|
    json.id episord.product.id
    json.title episord.product.title
    json.imageUrl episord.product.bgimage_url
    json.arasuzi episord.product.description
    json.year episord.product.year
    json.list episord.product.list
    json.productStyles do
      json.array! episord.product.styles
    end
    json.productGenres do
      json.array! episord.product.janls
    end
  
    # json.delivery_start episord.product.delivery_start
    json.deliveryStart episord.release_date

    json.productEpisord do
    json.arasuzi episord.arasuzi
    json.episord episord.episord
    json.releaseDate episord.release_date
    end

    json.productYearSeason2 do
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

