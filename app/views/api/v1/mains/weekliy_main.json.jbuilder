json.set! :weekly do
  json.array! @week_all do |week|
    json.id week.id
    json.week week.week
    json.products do
      json.array! week.products do |product|
        json.id product.id
        json.title product.title
        json.episords do
          # doneyet-2 n+1と余分 チェック いつか直す。2022/3/28
          json.array! product.episords
          # .left_outer_joins(:weeks).includes(:weeks).where(weeks:{id:week.id})
        end

        json.product_weekly do
          json.array! product.weeklyrankings do |w|
            json.id w.id
            json.count w.count
            json.weekly w.weekly
            #doneyet-2 ここにエピソードが関連づいてたら上の問題考慮せずにもってこれる。いつか直す2022/3/28
          end
        end

      end

    end 
  end
end


