# json.set! :review_comments do
#   # json.goodbad  @review_comments
#   json.array!  @review_comments do |comment|
#     json.id comment.id
#     json.comment comment.comment
#     json.like_comment comment.like_comment_reviews
#     # json.return_comment comment.return_comment_reviews
#     json.return_jugde comment.return_comment_reviews.present?
    
#   end
# end
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
    json.like_comment comment.like_comment_reviews
    # json.return_comment comment.return_comment_reviews
    json.return_jugde comment.return_comment_reviews.present?
    json.updated_at comment.updated_at.strftime("%Y/%-m/%-d")
    # json.user comment.user
    json.user do
      json.id comment.user.id
      json.nickname comment.user.nickname
      json.image comment.user.topimage_url
      # json.overview comment.user.overview
      # json.background_image comment.user.background_image
      # json.administrator_gold comment.user.administrator_gold
    end

    
  end
end