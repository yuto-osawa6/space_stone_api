class Api::V1::Comment::ReturnCommentThreadsController < ApplicationController
  def index
    params[:comment_thread_id]
    @returncomment = ReturnCommentThread.includes(:like_return_comment_threads,:user,return_returns: :user).where(comment_thread_id:params[:comment_thread_id]).page(params[:page]).per(3)
    # @returnUser= @returncomment.return_returns.ids
    # render json: {status:200 ,returncomment: @returncomment}
    render :index,formats: :json
  end

  def create
    begin
      @commentReview = ReturnCommentThread.new(create_params)
      @commentReview.save!
      render json: {status:200,commentReview:@commentReview}
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:return_comment_thread][:comment_thread_id])
          @EM = ErrorManage.new(controller:"return_comment_thread/create",error:"#{e}".slice(0,200))
          @EM.save
          render json: {status:500}
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end      
    end
  end
  def returnreturn
    begin
      @commentReview = ReturnCommentThread.new(create_params2)
      @commentReview.return_return_comment_threads.build(return_comment_thread_id:@commentReview.id,return_return_thread_id:params[:return_return_comment_thread][:return_return_thread_id])
      @commentReview.save!
        render :returnreturn, formats: :json
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:return_comment_thread][:comment_thread_id])
          if ReturnCommentThread.exists?(id:params[:return_return_comment_thread][:return_return_thread_id])
            @EM = ErrorManage.new(controller:"return_comment_thread/return_return",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:430}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end   
    end

  end

  def destroy
    begin
      @review_comment = ReturnCommentThread.find(params[:id])
      @review_comment.destroy
      render json: {status:200}
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:comment_thread_id])
          if ReturnCommentThread.exists?(id:params[:id])
            @EM = ErrorManage.new(controller:"return_comment_thread/destroy",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:420}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end
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


