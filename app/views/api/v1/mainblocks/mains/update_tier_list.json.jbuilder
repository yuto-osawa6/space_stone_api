json.set! :tier do
  json.array! @tier_p do |a|
    json.id a.id
    json.imageUrl a.bgimage_url
  end
end

json.set! :tierAverage do
  json.tierAvg @tier
end