class Api::V1::Comment::ReturnCommentThreadsController < ApplicationController
  def index
    params[:comment_thread_id]
    @returncomment = ReturnCommentThread.where(comment_thread_id:params[:comment_thread_id])
    # @returnUser= @returncomment.return_returns.ids
    # render json: {status:200 ,returncomment: @returncomment}
    render :index,formats: :json
  end

  def create
    @commentReview = ReturnCommentThread.new(create_params)
   
    if  @commentReview.save
      render json: {status:200,commentReview:@commentReview}
    else
      render json: {status:500}

    end
  end
  def returnreturn
    puts params[:return_comment_thread_id]
    @commentReview = ReturnCommentThread.new(create_params)
    @commentReview.return_return_comment_threads.build(return_create_params)
    # @commentReview.return_return_comment_reviews.build(return_return_id:2)


    if  @commentReview.save
      # @commentReview.return_return_comment_reviews.return_comment_review_id = params[:return_comment_review_id]

      render json: {status:200,commentReview:@commentReview}
    else
      render json: {status:500}

    end
  end
  private
  def create_params
    params.require(:return_comment_thread).permit(:user_id,:comment_thread_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end

  def return_create_params
    params.require(:return_return_comment_thread).permit(:return_comment_thread_id,:return_return_thread_id)
  end
  
end
