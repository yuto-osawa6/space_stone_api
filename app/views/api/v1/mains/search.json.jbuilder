# json.set! :products do 
#   json.array! @products do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     # json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end
#   end

  
#   # json.page @products.ids
#   # json.set! page, @products.num_page
# end

json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    # json.image_url product.image_url
    json.image_url product.bgimage_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    # json.season product.season
    # json.products_style product.styles.name
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
    # if product.delivery_start?
    #   if Date.today < product.delivery_start
    #     json.delivery_start product.delivery_start
    #   end
    # end
    json.pickup product.pickup
    # doneyet_1_priority (lengthの変更)
    # if product.scores.exists?
      # &&product.scores.length>0
    json.scores do
      json.array! product.scores
      # .average(:value).round(1)
    end

    # json.tags do
    #   json.array! product.tags
    # end

  end

end



json.set! :products_pages do
  json.page @products.total_pages
end 