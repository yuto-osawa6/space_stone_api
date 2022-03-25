json.set! :tier do
  json.array! @tier_p do |a|
    json.id a.id
    json.image_url a.bgimage_url
  end
end

json.set! :tier_average do
  json.tierAvg @tier
end