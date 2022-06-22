class Api::V1::CommentThreadsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]
  before_action :reCaptcha_check, only:[:create]

  def create
    begin
      @review = Thered.find(params[:thered_id])
      @review_length = @review.comment_threads.length
      # puts @review_length
      if @review_length>=Concerns::LIMIT_COMMENT[:comment]
        render json:{status:493}
        return
      end
      if @review.comment_threads.includes(:user).where(user_id:params[:comment_thread][:user_id]).length >= Concerns::LIMIT_COMMENT[:user_comment]
        render json:{status:493}
        return
      end

      if @review_length>=Concerns::LIMIT_COMMENT[:fortsetzen]
        last3 = @review.comment_threads.last(Concerns::LIMIT_COMMENT[:last])
        last3_count = last3.map{|k| k.user_id }.uniq.count
        if last3_count ==1
          if last3[0].user_id == params[:comment_thread][:user_id]
            render json:{status:490}
            return
          end
        end
      end

      @commentReview = CommentThread.new(commentReview_params)
      # @review = Thered.find(params[:thered_id])
      case params[:value]
      when 0 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
      when 1 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(created_at:"desc").page(params[:page]).per(5)
      when 2 then
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(created_at:"asc").page(params[:page]).per(5)
      else
        @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).include_tp_img.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
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
