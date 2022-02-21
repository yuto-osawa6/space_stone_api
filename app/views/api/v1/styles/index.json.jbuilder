json.set! :styles do
  json.array! @styles do |style|
    json.value style.id
    json.label style.name
  end
end