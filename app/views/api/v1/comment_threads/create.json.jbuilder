json.set! :status,200
json.set! :message do
  json.title "コメントを作成しました。"
  json.select 1
end

json.set! :review_comments do
  # json.goodbad  @review_comments
  json.array!  @review_comments do |comment|
    json.id comment.id
    json.comment comment.comment
    json.like_comment comment.like_comment_threads
    # json.return_comment comment.return_comment_reviews
    json.return_jugde comment.return_comment_threads.present?
    json.updated_at comment.updated_at.strftime("%Y/%-m/%-d")
    json.user do
      json.id comment.user.id
      json.nickname comment.user.nickname
      json.image comment.user.topimage_url
    end
    
  end
end