json.set! :tier_main do
  json.array! @tierGroup do |a|
    json.id  a.id
    json.year a.year
    json.kisetsu a.kisetsu
    json.avg a.tiers.where(user_id:@user.id).includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    json.products a.products.where(tiers:{user_id:@user.id}).includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc"))
  end
end

json.set! :tierGroupLength, @tierGroupLength