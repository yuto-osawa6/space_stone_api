class Api::V1::Comment::ReturnCommentThreadsController < ApplicationController
  def index
    params[:comment_thread_id]
    @returncomment = ReturnCommentThread.includes(:like_return_comment_threads,:user,return_returns: :user).where(comment_thread_id:params[:comment_thread_id]).page(params[:page]).per(3)
    # @returnUser= @returncomment.return_returns.ids
    # render json: {status:200 ,returncomment: @returncomment}
    render :index,formats: :json
  end

  def create
    @commentReview = ReturnCommentThread.new(create_params)
    begin
      if  @commentReview.save
        render json: {status:200,commentReview:@commentReview}
        # render :create, formats: :json
        # render :returnreturn, formats: :json
      else
        render json: {status:500}

      end
    rescue => exception
      render json: {status:500}      
    end
  end
  def returnreturn
    puts params[:return_comment_thread_id]
    @commentReview = ReturnCommentThread.new(create_params2)
    # @commentReview.return_return_comment_threads.build(return_create_params)

    @commentReview.return_return_comment_threads.build(return_comment_thread_id:@commentReview.id,return_return_thread_id:params[:return_return_comment_thread][:return_return_thread_id])


    
    begin
      if  @commentReview.save
        # @commentReview.return_return_comment_reviews.return_comment_review_id = params[:return_comment_review_id]
        # : {"return_comment_thread"=>{"comment_thread_id"=>6, "user_id"=>4, "comment"=>"<p>a</p>"}, "return_return_comment_thread"=>{"return_return_thread_id"=>12}}
        # {"return_comment_review"=>{"comment_review_id"=>13, "user_id"=>4, "comment"=>"<p>u</p><p><br></p>"}, "return_return_comment_review"=>{"return_return_id"=>30}}
        # {"return_comment_thread"=>{"comment_thread_id"=>6, "user_id"=>4, "comment"=>"<p>a</p>"}, "return_return_comment_thread"=>{"return_return_thread_id"=>14}}
        # render json: {status:200,commentReview:@commentReview}
        render :returnreturn, formats: :json
      else
        render json: {status:500}

      end
    rescue => exception
      render json: {status:500}      
    end
  end

  def destroy
    puts params
    begin
      @review_comment = ReturnCommentThread.find(params[:id])
      @review_comment.destroy
      render json: {}
    rescue => e
      render json: {status:500}
    end
  end
  private
  def create_params
    params.require(:return_comment_thread).permit(:user_id,:comment_thread_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end
  def create_params2
    params.require(:return_comment_thread).permit(:user_id,:comment_thread_id,:comment).merge(reply:true)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end

  # def return_create_params
  #   params.require(:return_return_comment_thread).permit(:return_comment_thread_id)
  # end
  
end


