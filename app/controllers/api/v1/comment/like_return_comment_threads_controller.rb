class Api::V1::Comment::LikeReturnCommentThreadsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]

  def create
    begin
      @LikeReturnCommentReview = LikeReturnCommentThread.where(user_id:params[:like_return_comment_thread][:user_id],return_comment_thread_id:params[:like_return_comment_thread][:return_comment_thread_id]).first_or_initialize
      @LikeReturnCommentReview.goodbad = params[:like_return_comment_thread][:goodbad]
      
      @LikeReturnCommentReview.save!
      @review_length = LikeReturnCommentThread.where(return_comment_thread_id:params[:like_return_comment_thread][:return_comment_thread_id]).length
      @review_good = LikeReturnCommentThread.where(return_comment_thread_id:params[:like_return_comment_thread][:return_comment_thread_id],goodbad:1).length
      @score = @review_good / @review_length * 100
      render json: {status:200, like: @LikeReturnCommentReview,score:@score,review_length:@review_length,review_good:@review_good}
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:comment_thread_id])
          if ReturnCommentThread.exists?(id:params[:like_return_comment_thread][:return_comment_thread_id])
            @EM = ErrorManage.new(controller:"like_return_comment_review/create",error:"#{e}".slice(0,200))
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

  def destroy
    begin
      @user = User.find(params[:user_id])
      @like = LikeReturnCommentThread.find_by(return_comment_thread_id: params[:return_comment_thread_id], user_id: @user.id)
      @like.destroy
      @review_length = LikeReturnCommentThread.where(return_comment_thread_id:params[:return_comment_thread_id]).length
      @review_good = LikeReturnCommentThread.where(return_comment_thread_id:params[:return_comment_thread_id],goodbad:1).length
      if  @review_length==0 && @review_good==0
        @score = 0
      else
        @score = @review_good / @review_length * 100
      end
      render json: { status: 200, message: "削除されました",score:@score,review_length:@review_length,review_good:@review_good } 
    rescue => e
      if Thered.exists?(id:params[:thread_id])
        if CommentThread.exists?(id:params[:comment_thread_id])
          if ReturnCommentThread.exists?(id:params[:return_comment_thread_id])
            if LikeReturnCommentThread.exists?(return_comment_thread_id: params[:return_comment_thread_id], user_id: params[:user_id])
              @EM = ErrorManage.new(controller:"like_return_comment_review/destroy",error:"#{e}".slice(0,200))
              @EM.save
              render json: {status:500}
            else
              render json: {status:440}
            end
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

  def index
    @review_length = LikeReturnCommentThread.where(return_comment_thread_id:params[:return_comment_thread_id]).length
    @review_good = LikeReturnCommentThread.where(return_comment_thread_id:params[:return_comment_thread_id],goodbad:1).length
  
    if  @review_length==0 && @review_good==0
      @score = 0
    else
      @score = @review_good / @review_length * 100
    end

    # @user_check = User.exists?(id:params[:user_id])
    if user_signed_in?
      
    else
      render json: { status: 201, message: "ログインされてません.",score:@score,review_length:@review_length,review_good:@review_good}
      return
    end
  
    @user = User.find(params[:user_id])
    # @like_review = LikeReview.where(user_id:params[:user_id])
    @liked = @user.like_return_comment_threads.exists?(return_comment_thread_id: params[:return_comment_thread_id])

    if @liked
      @like = LikeReturnCommentThread.find_by(return_comment_thread_id: params[:return_comment_thread_id], user_id: @user.id)
    end
    render :index,formats: :json
  end


end
