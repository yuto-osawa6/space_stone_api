json.set! :status ,200
json.set! :article do 
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.weekormonth @article.weekormonth
  # if ArticleProduct.exists?(article_id:article.id)
  json.hashtag_articles @article.hashtags
  json.article_products do
    json.array! @article.products do |product|
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

      # json.product_year_season2 do
      #   json.array! product.year_season_products do |a|
      #     json.id a.id
      #     json.year a.year
      #     json.season a.kisetsu
      #   end
      # end 
      
    end
  end
end
