json.set! :liked do
  json.liked @liked
    if @liked
      json.like @like.id
    end
  json.message "aaaaaaaa"
  end

json.set! :resouce do
  json.userReview do
  json.array! @review 
  end
  json.userScore do
  json.array! @score
  end
end