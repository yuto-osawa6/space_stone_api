class Api::V1::Comment::ReturnCommentThreadsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy,:returnreturn]

  def index
    @returncomment = ReturnCommentThread.includes(:like_return_comment_threads,:user,return_returns: :user).include_tp_img.where(comment_thread_id:params[:comment_thread_id]).page(params[:page]).per(3)
    render :index,formats: :json
  end

  def create
    begin
      @review = CommentThread.find(params[:return_comment_thread][:comment_thread_id])
      # @review = Review.find(params[:review_id])
      @review_length = @review.return_comment_threads.length
      if @review_length>=Concerns::LIMIT_COMMENT[:return_comment]
        render json:{status:494}
        return
      end
      if @review.return_comment_threads.includes(:user).where(user_id:params[:return_comment_thread][:user_id]).length >= Concerns::LIMIT_COMMENT[:user_comment]
        render json:{status:495}
        return
      end

      if @review_length>=Concerns::LIMIT_COMMENT[:fortsetzen]
        last3 = @review.return_comment_threads.last(Concerns::LIMIT_COMMENT[:last])
        last3_count = last3.map{|k| k.user_id }.uniq.count
        if last3_count ==1
          if last3[0].user_id == params[:return_comment_thread][:user_id]
            render json:{status:490}
            return
          end
        end
      end

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
      @review = CommentThread.find(params[:return_comment_thread][:comment_thread_id])
      # @review = Review.find(params[:review_id])
      @review_length = @review.return_comment_threads.length
      if @review_length>=Concerns::LIMIT_COMMENT[:return_comment]
        render json:{status:494}
        return
      end
      if @review.return_comment_threads.includes(:user).where(user_id:params[:return_comment_thread][:user_id]).length >= Concerns::LIMIT_COMMENT[:user_comment]
        render json:{status:495}
        return
      end

      if @review_length>=Concerns::LIMIT_COMMENT[:return_fortsetzen]
        last3 = @review.return_comment_threads.last(Concerns::LIMIT_COMMENT[:return_last])
        last3_count = last3.map{|k| k.user_id }.uniq.count
        if last3_count ==1
          if last3[0].user_id == params[:return_comment_thread][:user_id]
            render json:{status:490}
            return
          end
        end
      end


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
  end
  def create_params2
    params.require(:return_comment_thread).permit(:user_id,:comment_thread_id,:comment).merge(reply:true)
  end
end


