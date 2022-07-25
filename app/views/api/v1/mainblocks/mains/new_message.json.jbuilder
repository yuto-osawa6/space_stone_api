json.set! :decision_news do
  json.array! @new_message do |news|
    json.id news.id
    json.title news.title
    json.description news.description
    json.information news.information
    json.judge news.judge
    json.date news.date.strftime("%Y/%-m/%-d")
    # json.title product.title
    # json.image_url product.image_url
    # json.arasuzi product.description
  end
end
json.set! :length,@new_message_length