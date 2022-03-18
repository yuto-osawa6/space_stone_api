class Api::V1::Comment::ReturnCommentReviewsController < ApplicationController
  def index
    params[:comment_review_id]
    # userは対１関係なため、includesに含めない。
    # @review = CommentReview.includes(:like_comment_reviews).find(params[:comment_review_id])
    @returncomment = ReturnCommentReview.includes(:like_return_comment_reviews,:user,return_returns: :user).where(comment_review_id:params[:comment_review_id]).page(params[:page]).per(3)
    render :index,formats: :json
  end

  def create
    @commentReview = ReturnCommentReview.new(create_params)
    
    begin
      if  @commentReview.save
        render json: {status:200,commentReview:@commentReview}
      else
        render json: {status:500}

      end
    rescue => exception
      render json: {status:500}      
    end
  end
  def returnreturn
    puts params[:return_comment_review_id]
    @commentReview = ReturnCommentReview.new(create_params)
    @commentReview.return_return_comment_reviews.build(return_create_params)
    # @commentReview.return_return_comment_reviews.build(return_return_id:2)

    begin
      if  @commentReview.save
        # @commentReview.return_return_comment_reviews.return_comment_review_id = params[:return_comment_review_id]

        # render json: {status:200,commentReview:@commentReview}
        render :returnreturn, formats: :json
      else
        render json: {status:500}

      end
    rescue => exception
      render json: {status:500}      
    end
  end
  private
  def create_params
    params.require(:return_comment_review).permit(:user_id,:comment_review_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end

  def return_create_params
    params.require(:return_return_comment_review).permit(:return_comment_review_id,:return_return_id)
  end
  
end
