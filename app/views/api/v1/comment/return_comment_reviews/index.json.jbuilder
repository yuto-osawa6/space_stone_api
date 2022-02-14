json.set! :status, 200

# json.set!  :comment_review do
#   json.id @review.id
#   # json.title @review.title
#   json.comment @review.comment
#   json.user_id @review.user_id
#   # json.like_comment comment.like_comment_reviews
#   json.user @review.user
#   json.updated_at @review.updated_at.strftime("%Y/%-m/%-d")

# end

json.set! :returncomment do
  json.array! @returncomment do |returncomment|
    json.id returncomment.id
    json.comment returncomment.comment
    json.user_id returncomment.user_id
    # json.like_comment returncomment.like_comment_reviews
    json.comment_review_id returncomment.comment_review_id

    json.like_return_comment_reviews returncomment.like_return_comment_reviews
    json.user returncomment.user
    json.updated_at returncomment.updated_at.strftime("%Y/%-m/%-d")

    if returncomment.return_returns[0].present?
    # json.return returncomment.return_returns
    json.return_return returncomment.return_returns[0].user
    end
  end
end