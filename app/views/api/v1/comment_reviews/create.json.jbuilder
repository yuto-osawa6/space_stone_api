json.set! :review_comments do
  # json.goodbad  @review_comments
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.like_comment comment.like_comment_reviews
    # json.return_comment comment.return_comment_reviews
    json.return_jugde comment.return_comment_reviews.present?
    
  end
end