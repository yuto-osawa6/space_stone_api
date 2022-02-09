json.set! :like_topten_month do
  json.array! @like_topten_month do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
    json.likes product.likes
  end
end

json.set! :like_topten_all  do
  json.array! @like_topten_all do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
  end
end
json.set! :score_topten_all do
  json.array! @score_topten_all do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
  end
end
json.set! :acsess_topten_month do
  json.array! @acsess_topten_month do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
    json.acsesses product.acsesses
  end
end
json.set! :acsess_topten_all do
  json.array! @acsess_topten_all do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
    json.acsesses product.acsesses
  end
end

json.set! :review_topten_month do
  json.array! @review_topten_month do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
    json.reviews product.reviews
  end
end

json.set! :review_topten_all do
  json.array! @review_topten_all do |product|

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

    if product.delivery_end?
      # if Date.today < product.delivery_end
        json.delivery_end product.delivery_end
      # end
    end
    if product.delivery_start?
      # if Date.today < product.delivery_start
        json.delivery_start product.delivery_start
      # end
    end
    json.reviews product.reviews
  end
end