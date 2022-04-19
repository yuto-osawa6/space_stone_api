class Api::V1::LikeThreadsController < ApplicationController
  def create
    begin
      @like = LikeThread.where(user_id:params[:user_id],thered_id:params[:thered_id]).first_or_initialize
      @like.goodbad = params[:goodbad]
      if @like.save
          @review_length = LikeThread.where(thered_id:params[:thered_id]).length
          @review_good = LikeThread.where(thered_id:params[:thered_id],goodbad:1).length
          @score = @review_good / @review_length * 100
        render json: { status: 200, like: @like,score:@score,review_length:@review_length,review_good:@review_good} 
      else
        if Thered.exists?(id:params[:thered_id])
          render json: { status: 500 } 
        else
          render json: { status: 400 } 
        end
      end
    rescue => e
      @EM = ErrorManage.new(controller:"like_thread/create",error:"#{e}".slice(0,200))
      @EM.save
      render json: { status: 500 } 
    end
  end

  def destroy
    begin
      @user = User.find(params[:user_id])
      @like = LikeThread.find_by(thered_id: params[:thered_id], user_id: @user.id)
      @like.destroy
      @review_length = LikeThread.where(thered_id:params[:thered_id]).length
      @review_good = LikeThread.where(thered_id:params[:thered_id],goodbad:1).length

      if  @review_length==0 && @review_good==0
        @score = 0
      else
        @score = @review_good / @review_length * 100
      end
      render json: { status: 200, message: "削除されました"  ,score:@score,review_length:@review_length,review_good:@review_good } 
    rescue => e
      if Thered.exists?(id:params[:thered_id])
        if LikeThread.exists?(id:params[:thered_id], user_id: params[:user_id])
          @EM = ErrorManage.new(controller:"like_thread/delete",error:"#{e}".slice(0,200))
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
    @review_length = LikeThread.where(thered_id:params[:thered_id]).length
    @review_good = LikeThread.where(thered_id:params[:thered_id],goodbad:1).length
    if  @review_length==0 && @review_good==0
      @score = 0
      puts "aaaaaaaaaaaaaaa"
    else
      @score = @review_good / @review_length * 100
    end
    @user_check = User.exists?(id:params[:user_id])
    if @user_check == false 
      render json: { status: 201, message: "ログインされてません.",score:@score,review_length:@review_length,review_good:@review_good}
      return
    end
    # puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    @user = User.find(params[:user_id])
    # @like_review = LikeReview.where(user_id:params[:user_id])
    @liked = @user.like_threads.exists?(thered_id: params[:thered_id])
    if @liked
      @like = LikeThread.find_by(thered_id: params[:thered_id], user_id: @user.id)
    end
    render :check,formats: :json
  end

  private
  def like_params
    params.require(:like_review).permit(:review_id,:goodbad,:user_id)
  end
end
