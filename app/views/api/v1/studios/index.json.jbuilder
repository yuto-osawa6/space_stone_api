json.set! :genres do
  json.array! @studios do |style|
    json.value style.id
    json.label style.company
  end
end