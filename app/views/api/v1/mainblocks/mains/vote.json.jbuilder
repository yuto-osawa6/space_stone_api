# json.set! :products do
#   json.array! @products do |product|
#     json.id product.id
#     json.title product.title
#     # json.image_url product.image_url
#     # json.arasuzi product.description
#     # json.year product.year
#     # json.duration  product.duration 
    
#     # json.scores do
#     #   json.array! product.scores
#     # end
#     json.product_episord do
#       json.array! product.episords
#     end
#     json.product_weekly do
#       json.array! product.weeklyrankings
#     end
#   end
  

# end

json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.product_episord do
      json.array! product.episords
    end
    json.product_weekly do
      json.array! product.weeklyrankings do |w|
        json.id w.id
        json.count w.count
        json.weekly w.weekly
        # j
      end
    end
  end
  

end

json.set! :weekly_count,@weekly_count
json.set! :from,@from
json.set! :to,@to
json.set! :weekly_vote,@weekly_vote

