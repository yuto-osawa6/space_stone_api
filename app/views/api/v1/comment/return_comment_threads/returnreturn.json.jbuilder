json.set! :status, 200

# json.set! :commentReview do
#   json.comment @commentReview.comment
#   json.comment_review_id @commentReview.comment_thread_id
#   json.id @commentReview.id
#   json.user_id @commentReview.user_id
#   if @commentReview.return_returns[0].present?
#     json.return @commentReview.return_returns[0].user_id
#   end
# end