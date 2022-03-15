
json.set! :tier_main do
  json.array! @tierGroup do |a|
    json.id  a.id
    json.year a.year
    json.kisetsu a.kisetsu
    json.avg a.tiers.includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    json.products a.products.includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc"))
  end
end

json.set! :tierGroupLength, @tierGroupLength