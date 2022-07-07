
json.set! :tier_main do
  json.array! @tierGroup do |a|
    json.id  a.id
    json.year a.year
    json.kisetsu a.kisetsu
    json.avg a.tiers.includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    # json.aliceT a.id
    json.products do
      json.array! a.products.includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc")) do |a|
        json.id a.id
        json.image_url a.bgimage_url
        json.title a.title
        json.arasuzi a.description
        json.list a.list
      end
    end

  end
end

json.set! :tierGroupLength, @tierGroupLength

# json.set! :aliceT,@tierGroup.id