class Api::V1::CommentReviewsController < ApplicationController
  def create
    @commentReview = CommentReview.new(commentReview_params)
    # @commentReview = CommentReview.new(user_id:params[:user_id],review_id:params[:review_id],comment:params[:comment])

    puts params[:user_id]
    puts params[:review_id]
    puts params[:comment]
    if  @commentReview.save
      render json: {status:200,commentReview:@commentReview}
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
