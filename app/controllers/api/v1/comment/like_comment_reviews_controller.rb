class Api::V1::Comment::LikeCommentReviewsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]

  def create
    begin
      @LikeCommentReview = LikeCommentReview.where(user_id:params[:like_comment_review][:user_id],comment_review_id:params[:like_comment_review][:comment_review_id]).first_or_initialize
      @LikeCommentReview.goodbad = params[:like_comment_review][:goodbad]
      @LikeCommentReview.save!
      @review_length = LikeCommentReview.where(comment_review_id:params[:like_comment_review][:comment_review_id]).length
      @review_good = LikeCommentReview.where(comment_review_id:params[:like_comment_review][:comment_review_id],goodbad:1).length
      @score = @review_good / @review_length.to_f * 100
      render json: {status:200, like: @LikeCommentReview,score:@score,review_length:@review_length,review_good:@review_good}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:like_comment_review][:comment_review_id])
          @EM = ErrorManage.new(controller:"like_comment_review/create",error:"#{e}".slice(0,200))
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
      @like = LikeCommentReview.find_by(comment_review_id: params[:comment_review_id], user_id: @user.id)
      @like.destroy

      @review_length = LikeCommentReview.where(comment_review_id:params[:comment_review_id]).length
      @review_good = LikeCommentReview.where(comment_review_id:params[:comment_review_id],goodbad:1).length
    
      if  @review_length==0 && @review_good==0
        @score = 0
      else
        @score = @review_good / @review_length.to_f * 100
      end
      render json: { status: 200, message: "削除されました",score:@score,review_length:@review_length,review_good:@review_good } 
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:comment_review_id])
          # 本来はid持ってくるべき
          if LikeCommentReview.exists?(comment_review_id: params[:comment_review_id], user_id: @user.id)
            @EM = ErrorManage.new(controller:"like_comment_review/destroy",error:"#{e}".slice(0,200))
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
    # nouse notest
    @review_length = LikeCommentReview.where(comment_review_id:params[:comment_review_id]).length
    @review_good = LikeCommentReview.where(comment_review_id:params[:comment_review_id],goodbad:1).length
  
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
    @liked = @user.like_comment_reviews.exists?(comment_review_id: params[:comment_review_id])
    
    if @liked
      @like = LikeCommentReview.find_by(comment_review_id: params[:comment_review_id], user_id: @user.id)
    end
    render :check,formats: :json
  end

  private
  def create_params 
    params.require(:like_comment_review).permit(:user_id,:comment_review_id,:goodbad)
  end
end
