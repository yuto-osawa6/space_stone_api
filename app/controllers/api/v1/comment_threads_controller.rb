class Api::V1::CommentThreadsController < ApplicationController
  def create
    begin
      @commentReview = CommentThread.new(commentReview_params)
      @review = Thered.find(params[:thered_id])
      case params[:value]
      when 0 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
      when 1 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(created_at:"desc").page(params[:page]).per(5)
      when 2 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(created_at:"asc").page(params[:page]).per(5)
      else
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
      end

      @commentReview.save!
      render  :create,formats: :json
    rescue => e
      if Thered.exists?(id:params[:thered_id])
        @EM = ErrorManage.new(controller:"comment_thread/create",error:"#{e}".slice(0,200))
        @EM.save
        render json: {status:500}
      else
        render json: {status:400}
      end
    end
  end

  def destroy
    begin
      @review_comment = CommentThread.find(params[:id])
      @review_comment.destroy
      render json: {status:200}
    rescue => e
      if Thered.exists?(id:params[:thered_id])
        if CommentThread.exists?(id:params[:id])
          @EM = ErrorManage.new(controller:"comment_thread/destroy",error:"#{e}".slice(0,200))
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
  private
  def commentReview_params
    params.require(:comment_thread).permit(:user_id,:thered_id,:comment)
  end
end
