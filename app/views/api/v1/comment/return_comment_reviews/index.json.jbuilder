json.set! :status, 200
# json.set! :like do
#   json.score @score 
#   json.liked @liked
#     if @liked
#       json.id @like.id
#       json.goodbad @like.goodbad
#     else
#       json.id 0
#       json.goodbad 0
#     end
#   json.review_length @review_length
#   json.review_good @review_good
#   # json.message "aaaaaaaa"
#   end
json.set! :returncomment do
  json.array! @returncomment do |returncomment|
    json.id returncomment.id
    json.comment returncomment.comment
    json.user_id returncomment.user_id
    json.comment_review_id returncomment.comment_review_id
    if returncomment.return_returns[0].present?
    json.return returncomment.return_returns[0].user_id
    end
  end
end