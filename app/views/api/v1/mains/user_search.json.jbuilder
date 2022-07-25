json.set! :user do
  json.array! @user do |u|
  json.id u.id
  json.nickname u.nickname
  json.image u.topimage_url
  end
end