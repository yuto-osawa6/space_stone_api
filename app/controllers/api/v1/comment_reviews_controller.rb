class Api::V1::CommentReviewsController < ApplicationController
  def create
    @commentReview = CommentReview.new(commentReview_params)

    puts params[:select_sort]

    # doneyet-over order switching system (over(check,select=>number))
    @review = Review.find(params[:review_id])

    case params[:select_sort]

    when 0 then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    when 1 then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews).order(created_at:"desc")
    when 2 then
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews).order(created_at:"asc")
    else
      @review_comments = @review.comment_reviews.includes(:like_comment_reviews,:return_comment_reviews).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    end

    if  @commentReview.save
      render :create,formats: :json
    else
      render json: {status:500}

    end
  end
  private
  def commentReview_params
    params.require(:comment_review).permit(:user_id,:review_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end
end
