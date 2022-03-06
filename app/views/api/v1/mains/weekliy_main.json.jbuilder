json.set! :weekly do
  json.array! @week_all do |week|
    json.id week.id
    json.week week.week
    json.products do
      
      json.array! week.products do |product|
        json.id product.id
        json.title product.title

        json.episords do
          json.array! product.episords
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
  end
end


