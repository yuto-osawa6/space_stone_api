json.set! :liked do
  json.liked @liked
    if @liked
      json.like @like.id
    end
  json.message "aaaaaaaa"
  end