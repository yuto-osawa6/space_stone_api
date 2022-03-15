json.set! :liked do
  json.liked @liked
    if @liked
      json.like @like.id
    end
  json.message "aaaaaaaa"
  end

json.set! :resouce do
  json.userReview do
    json.array! @review do |a|
      json.id a.id
      json.content a.content
      json.episord_id a.episord_id
      json.set! :emotions do
        json.array! a.emotions
      end
    end
  end
  json.userScore do
  json.array! @score
  end
end