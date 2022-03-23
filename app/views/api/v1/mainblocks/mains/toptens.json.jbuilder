json.set! :like_topten_month do
  json.array! @like_topten_month do |product|

    json.id product.id
    json.title product.title
    # json.image_url product.image_url
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end

    json.likes product.likes

    json.product_year do
      json.array! product.year_season_years.distinct do |ys|
        json.id ys.id
        json.year ys.year
        json.y ys.year_season_seasons
      end
    end

    json.product_season do
      json.array! product.year_season_seasons do |ys|
        json.id ys.id
        json.name ys.name
      end
    end
    json.productYearSeason do
      json.array! product.year_season_products
    end

  end
end

json.set! :like_topten_all  do
  json.array! @like_topten_all do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
    json.likes product.likes
  end
end
json.set! :score_topten_month do
  json.array! @score_topten_month do |product|

    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
  end
end
json.set! :score_topten_all do
  json.array! @score_topten_all do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
  end
end
json.set! :acsess_topten_month do
  json.array! @acsess_topten_month do |product|

    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end

    json.acsesses product.acsesses
  end
end
json.set! :acsess_topten_all do
  json.array! @acsess_topten_all do |product|
    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
    json.acsesses product.acsesses
  end
end

json.set! :review_topten_month do
  json.array! @review_topten_month do |product|

    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
    json.reviews product.reviews
  end
end

json.set! :review_topten_all do
  json.array! @review_topten_all do |product|

    json.id product.id
    json.title product.title
    json.image_url product.bgimage_url
    json.duration product.duration
    json.year product.year
    json.list product.list
    json.finished product.finished

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.scores do
      json.array! product.scores
    end
    json.reviews product.reviews
  end
end