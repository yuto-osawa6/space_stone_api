json.set! :products do
  json.array! @products do |product|
    json.id product.id
    json.title product.title
    json.episords do
      # n+1問題 ３冊目の最後の方 ピンク紫
      json.array! product.episords
      # .where(release_date:@from...@to)
    end
    json.product_weekly do
      json.array! product.weeklyrankings do |w|
        json.id w.id
        json.count w.count
        json.weekly w.weekly
      end
    end
  end
  

end

json.set! :weekly_count,@weekly_count
json.set! :from,@from
json.set! :to,@to
json.set! :weekly_vote,@weekly_vote

