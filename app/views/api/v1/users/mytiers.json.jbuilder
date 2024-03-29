json.set! :tier_main do
  json.array! @tierGroup do |a|
    json.id  a.id
    json.year a.year
    json.kisetsu a.kisetsu
    json.avg a.tiers.where(user_id:@user.id).includes(:product).group("product_id").order(Arel.sql("avg(tiers.tier) desc")).average(:tier)
    json.products do 
      json.array! a.products.with_attached_bg_images.where(tiers:{user_id:@user.id}).includes(:tiers).group("product_id").order(Arel.sql("avg(tiers.tier) desc")) do |b|
        json.id b.id
        json.image_url b.bgimage_url
        json.title b.title
        json.arasuzi b.description
        json.list b.list
      end
    end
    
  end
end

json.set! :tierGroupLength, @tierGroupLength