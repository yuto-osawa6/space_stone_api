class Api::V1::LikeReviewsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]
  def create
    begin
      @like = LikeReview.where(user_id:params[:user_id],review_id:params[:review_id]).first_or_initialize
      @like.goodbad = params[:goodbad]
      if @like.save
        @review_length = LikeReview.where(review_id:params[:review_id]).length
        @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
        @score = @review_good / @review_length.to_f * 100
        render json: { status: 200, like: @like,score:@score,review_length:@review_length,review_good:@review_good} 
      else
        if Review.exists?(id:params[:review_id])
          render json: { status: 500 } 
        else
          render json: { status: 400 } 
        end
      end
    rescue => e
      @EM = ErrorManage.new(controller:"like_review/create",error:"#{e}".slice(0,200))
      @EM.save
      render json: { status: 500 } 
    end
  end

  def destroy
    begin
      @user = User.find(params[:user_id])
      @like = LikeReview.find_by(review_id: params[:review_id], user_id: @user.id)
      @like.destroy!
      @review_length = LikeReview.where(review_id:params[:review_id]).length
      @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
      if  @review_length==0 && @review_good==0
      @score = 0
      else
      @score = @review_good / @review_length.to_f * 100
      end
      render json: { status: 200, message: "削除されました"  ,score:@score,review_length:@review_length,review_good:@review_good } 
    rescue => e
      if Review.exists?(id:params[:review_id])
        if LikeReview.exists?(id:params[:review_id], user_id: params[:user_id])
          @EM = ErrorManage.new(controller:"like_review/delete",error:"#{e}".slice(0,200))
          @EM.save
          render json: {status:500}
        else
          render json: { status: 440 } 
        end
      else
        render json: { status: 400 } 
      end
    end
  end

  def check
    # nouse 
    @review_length = LikeReview.where(review_id:params[:review_id]).length
    @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
    if  @review_length==0 && @review_good==0
      @score = 0
    else
      @score = @review_good / @review_length * 100
    end
    # @user_check = User.exists?(id:params[:user_id])
    # if @user_check == false 
    if user_signed_in?
    else
      render json: { status: 201, message: "ログインされてません.",score:@score,review_length:@review_length,review_good:@review_good}
      return
    end
    @user = User.find(params[:user_id])
    @liked = @user.like_reviews.exists?(review_id: params[:review_id])
    if @liked
      @like = LikeReview.find_by(review_id: params[:review_id], user_id: @user.id)
    end
    render :check,formats: :json
  end

  private
  def like_params
    params.require(:like_review).permit(:review_id,:goodbad,:user_id)
  end
end
