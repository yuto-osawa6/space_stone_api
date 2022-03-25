class Api::V1::Comment::LikeCommentThreadsController < ApplicationController
  def create
    begin
      @LikeCommentReview = LikeCommentThread.where(user_id:params[:like_comment_thread][:user_id],comment_thread_id:params[:like_comment_thread][:comment_thread_id]).first_or_initialize
      @LikeCommentReview.goodbad = params[:like_comment_thread][:goodbad]
      
      @LikeCommentReview.save!
      @review_length = LikeCommentThread.where(comment_thread_id:params[:like_comment_thread][:comment_thread_id]).length
      @review_good = LikeCommentThread.where(comment_thread_id:params[:like_comment_thread][:comment_thread_id],goodbad:1).length
      @score = @review_good / @review_length * 100
      render json: {status:200, like: @LikeCommentReview,score:@score,review_length:@review_length,review_good:@review_good}
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:like_comment_thread][:comment_thread_id])
          @EM = ErrorManage.new(controller:"like_comment_thread/destroy",error:"#{e}".slice(0,200))
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

  def destroy
    begin
      @user = User.find(params[:user_id])
      @like = LikeCommentThread.find_by(comment_thread_id: params[:comment_thread_id], user_id: @user.id)
      @like.destroy
      @review_length = LikeCommentThread.where(comment_thread_id:params[:comment_thread_id]).length
      @review_good = LikeCommentThread.where(comment_thread_id:params[:comment_thread_id],goodbad:1).length
      if  @review_length==0 && @review_good==0
        @score = 0
      else
        @score = @review_good / @review_length * 100
      end
      render json: { status: 200, message: "削除されました",score:@score,review_length:@review_length,review_good:@review_good } 
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:comment_thread_id])
          if LikeCommentThread.exists?(comment_thread_id: params[:comment_thread_id], user_id: @user.id)
            @EM = ErrorManage.new(controller:"like_comment_thread/destroy",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:440}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end
    end
  end

  def check
    @review_length = LikeCommentThread.where(comment_thread_id:params[:comment_thread_id]).length
    @review_good = LikeCommentThread.where(comment_thread_id:params[:comment_thread_id],goodbad:1).length
  
    if  @review_length==0 && @review_good==0
      @score = 0
    else
      @score = @review_good / @review_length * 100
    end

    @user_check = User.exists?(id:params[:user_id])
    if @user_check == false 
      render json: { status: 201, message: "ログインされてません.",score:@score,review_length:@review_length,review_good:@review_good}
      return
    end

    @user = User.find(params[:user_id])
    # @like_review = LikeReview.where(user_id:params[:user_id])
    @liked = @user.like_comment_threads.exists?(comment_thread_id: params[:comment_thread_id])
    
    if @liked
      @like = LikeCommentThread.find_by(comment_thread_id: params[:comment_thread_id], user_id: @user.id)
    end
    render :check,formats: :json
  end

  private
  def create_params 
    params.require(:like_comment_thread).permit(:user_id,:comment_thread_id,:goodbad)
  end
end
