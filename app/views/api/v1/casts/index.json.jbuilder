json.set! :casts do
  json.array! @janls do |janl|
    json.value janl.id
    json.label janl.name
  end
end