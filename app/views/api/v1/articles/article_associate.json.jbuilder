json.set! :articles do
  # puts @Articles 
  
  json.array! @articles do |article|
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
  end
end

json.set! :articles2 do
  json.array! @articles2 do |article2|
    json.id article2.id
    json.title article2.title
    json.content article2.content
    json.weekormonth article2.weekormonth
    # if ArticleProduct.exists?(article_id:article.id)
    json.article_products do
      json.array! article2.products do |product|
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
  end
end

