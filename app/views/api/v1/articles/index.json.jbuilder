json.set! :articles do
  # puts @Articles 
  
  json.array! @Articles do |article|
    json.id article.id
    json.title article.title
    json.content article.content
    json.weekormonth article.weekormonth
    # if ArticleProduct.exists?(article_id:article.id)
      json.article_products do
        json.array! article.products do |product|
          json.id product.id
          json.title product.title
          json.image_url product.bgimage_url
          json.arasuzi product.description
          json.year product.year
          json.duration  product.duration 
          json.list product.list
          json.product_styles do
            json.array! product.styles
          end
          json.product_genres do
            json.array! product.janls
          end
        end
      end
    # end
  end
end
json.set! :article_length,@Article_length



# json.set! :products do 
#   json.array! @products do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     json.products_style product.styles.name
#     json.product_styles do
#       json.array! product.styles
#     end
#     json.product_genres do
#       json.array! product.janls
#     end
#   end
# end
