json.set! :staffs do
  json.array! @staffs do |style|
    json.value style.id
    json.label style.name
  end
end