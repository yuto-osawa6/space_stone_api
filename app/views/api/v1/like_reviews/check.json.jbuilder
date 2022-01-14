json.set! :like do
  json.liked @liked
  json.score @score 
    if @liked
      json.id @like.id
      json.goodbad @like.goodbad
    else
      json.id 0
      json.goodbad 0
    end
  json.review_length @review_length
  json.review_good @review_good
  # json.message "aaaaaaaa"
  end