# json.set! :products do 
#   json.array! @products do |product|
#     json.id product.id
#     json.title product.title
#     json.image_url product.image_url
#     json.arasuzi product.description
#     # # json.products_style product.styles.name
#     # json.product_styles do
#     #   json.array! product.styles
#     # end
#     # json.product_genres do
#     #   json.array! product.janls
#     # end
#   end
# end

json.set! :mains do
  json.array! @new_netflix do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end

end

json.set! :decision_news do
  json.array! @decision_news do |news|
    json.id news.id
    json.title news.title
    json.description news.description
    json.judge news.judge
    json.date news.updated_at.strftime("%-m/%-d")
    # json.title product.title
    # json.image_url product.image_url
    # json.arasuzi product.description
  end
end

json.set! :pickup do
  json.array! @pickup do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end

json.set! :delivery_end do
  json.array! @delivery_end do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.delivery_end product.delivery_end
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end


json.set! :delivery_start do
  json.array! @delivery_start do |product|
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.arasuzi product.description
    json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    # json.product_styles do
    #   json.array! product.styles
    # end
    # json.product_genres do
    #   json.array! product.janls
    # end
  end
end



json.set! :world_ranking do
  json.array! @topten do |product|
    json.id product.product.id
    # json.title product.title
    json.image_url product.image_url
    json.title  product.product.title
    json.arasuzi product.product.description
    json.duration product.product.duration
    json.year product.product.year
    json.list product.product.list
    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    json.product_styles do
      json.array! product.product.styles
    end
    json.product_genres do
      json.array! product.product.janls
    end
  end
end

i = 1
pre = 0
s = 0

json.set! :like_topten_month do
  json.array! @like_topten_month do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list

    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    json.likeCount v
    if product.scores.exists?
    json.averagescore product.scores.average(:value).round(1)
    json.averagescorecount product.scores.count(:value).round(1)
    end

    # if product.finished == true || product.delivery_end != nil
    #   if product.delivery_end <= Date.today
    #     json.endJudge "非公開"
    #   else
    #     json.endJudge "公開中"
    #   end
    # else
    #   json.endJudge "公開中"
    # end
    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end

i = 1
pre = 0
s = 0

json.set! :like_topten_all do
  json.array! @like_topten_all do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list


    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    json.likeCount v
    if product.scores.exists?
      json.averageScore product.scores.average(:value).round(1)
      json.averageScoreCount product.scores.count(:value).round(1)
    end
    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name
    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end

i = 1
pre = 0
s = 0

json.set! :score_topten_month do
  json.array! @score_topten_month do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    # json.averageScore v.round(1)

    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end
    # json.averageScore v.round(1)
    # json.averageScoreCount k
    if product.scores.exists?
      json.averageScore product.scores.average(:value).round(1)
      json.averageScoreCount product.scores.count(:value).round(1)
    end

    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end


i = 1
pre = 0
s = 0

json.set! :score_topten_all do
  json.array! @score_topten_all do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end
    if product.scores.exists?
      json.averageScore product.scores.average(:value).round(1)
      json.averageScoreCount product.scores.count(:value).round(1)
    end

    # if product.scores.exists?
      # json.averageScore product.scores.average(:value).round(1)
      # json.averageScoreCount product.scores.count(:value).round(1)
      json.averageScore v.round(1)
      json.averageScoreCount k

    # end
    

    # if product.finished == true || product.delivery_end != nil
    #   if product.delivery_end <= Date.today
    #     json.endJudge "非公開"
    #   else
    #     json.endJudge "公開中"
    #   end
    # else
    #   json.endJudge "公開中"
    # end
    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end


    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end


i = 1
pre = 0
s = 0

json.set! :acsess_topten_month do
  json.array! @acsess_topten_month do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    if product.scores.exists?
      json.averageScore product.scores.average(:value).round(1)
      json.averageScoreCount product.scores.count(:value).round(1)
    end

    # if product.finished == true || product.delivery_end != nil
    #   if product.delivery_end <= Date.today
    #     json.endJudge "非公開"
    #   else
    #     json.endJudge "公開中"
    #   end
    # else
    #   json.endJudge "公開中"
    # end
    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end


    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end

i = 1
pre = 0
s = 0

json.set! :acsess_topten_all do
  json.array! @acsess_topten_all do |k,v|

    
    product = Product.find(k)
    json.id product.id
    json.title product.title
    json.image_url product.image_url
    json.duration product.duration
    json.year product.year
    json.list product.list

    json.product_styles do
      json.array! product.styles
    end
    json.product_genres do
      json.array! product.janls
    end

    if product.scores.exists?
      json.averageScore product.scores.average(:value).round(1)
      json.averageScoreCount product.scores.count(:value).round(1)
    end

    # if product.finished == true || product.delivery_end != nil
    #   if product.delivery_end <= Date.today
    #     json.endJudge "非公開"
    #   else
    #     json.endJudge "公開中"
    #   end
    # else
    #   json.endJudge "公開中"
    # end
    if product.finished == true && product.delivery_end != nil || product.delivery_start != nil
      if product.delivery_end != nil
        if product.delivery_end <= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
      if product.delivery_start != nil
        if product.delivery_start >= Date.today
          json.endJudge "非公開"
        else
          json.endJudge "公開中"
        end
      else
        json.endJudge "非公開"
      end
    else
      json.endJudge "公開中"
    end

    # json.arasuzi product.description
    # json.delivery_start product.delivery_start
    # # json.products_style product.styles.name

    if v == pre
      json.rank s
    else
      json.rank i
      s = i 
    end
    pre = v
    i += 1
  end
end

json.set! :tags do
  json.array! @year do |year|
    json.year_id year.id
    json.year year.year
  end
  json.array! @season do |season|
    json.season_id season.id
    json.season season.season
  end
  # json.array! @tags do |tag|
  #   json.tag_id tag.id
  #   json.tag tag.month.strftime("%Y年%-m月")
  # end

end

json.set! :top100 do
  json.array! @tags do |tag|
    json.tag_id tag.id
    json.tag tag.month.strftime("%Y年%-m月")
  end
end