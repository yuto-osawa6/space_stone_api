
# json.set! :delivery_end do
#   json.array! @delivery_end do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     json.delivery_end product.delivery_end
#     # # json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end
#   end
# end


# json.set! :delivery_start do
#   json.array! @delivery_start do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     json.delivery_start product.delivery_start
#     # # json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end
#   end
# end

# json.set! :@delivery_end do
#   json.array! @delivery_end do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     json.year product.year
#     json.duration  product.duration 
#     json.list product.list
#     # json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end

#     # if product.delivery_end?
#       # if Date.today < product.delivery_end
#         json.delivery_end product.delivery_end
#       # end
#     # end
#     if product.delivery_start?
#       if Date.today < product.delivery_start
#         json.delivery_end product.delivery_start
#       end
#     end
#     json.pickup product.pickup
#     # doneyet_1_priority (lengthの変更)
#     # if product.scores.exists?
#       # &&product.scores.length>0
#     json.scores do
#       json.array! product.scores
#       # .average(:value).round(1)
#     end

#     json.tags do
#       json.array! product.tags
#     end

#   end

# end
json.set! :delivery_start do
  json.array! @delivery_start do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.year product.year
    json.duration  product.duration 
    json.list product.list
    # json.products_style product.styles.name
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    if product.delivery_end?
      if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      end
    end
    # if product.delivery_start?
    #   if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
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

    json.tags do
      json.array! product.tags
    end

  end

end

json.set! :episord_start do
  json.array! @episord do |episord|
    json.id episord.product.id
    json.title episord.product.title
    json.image_url episord.product.image_url
    json.arasuzi episord.product.description
    json.year episord.product.year
    # json.duration  product.duration 
    json.list episord.product.list
    json.product_styles do
      json.array! episord.product.styles
    end
    json.product_genres do
      json.array! episord.product.janls
    end
  
    # json.delivery_start episord.product.delivery_start
    json.delivery_start episord.release_date

    json.scores do
      json.array! episord.product.scores
    end

    json.product_episord do
    json.arasuzi episord.arasuzi
    json.episord episord.episord
    json.release_date episord.release_date
    end

  end
end

