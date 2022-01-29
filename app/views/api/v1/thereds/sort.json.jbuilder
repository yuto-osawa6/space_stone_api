json.set! :review_comments do
  # json.goodbad  @review_comments
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    
  end
end