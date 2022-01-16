class Api::V1::LikeThreadsController < ApplicationController
  def create
    # @user = User.find(params[:like_review][:user_id])
    # @like = @user.like_reviews.new(like_params)
    # @like = LikeReview.new(like_params)
    @like = LikeThread.where(user_id:params[:user_id],thered_id:params[:thered_id]).first_or_initialize
    @like.goodbad = params[:goodbad]
    puts params[:goodbad]

    if @like.save
        @review_length = LikeThread.where(thered_id:params[:thered_id]).length
        @review_good = LikeThread.where(thered_id:params[:thered_id],goodbad:1).length
        @score = @review_good / @review_length * 100
        puts @score
      # @like = Product.find(params[:like][:product_id]).likes.count
      # render json: { status: 200, like: @like,score:@score} 
      render json: { status: 200, like: @like,score:@score,review_length:@review_length,review_good:@review_good} 

    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @like = LikeThread.find_by(thered_id: params[:thered_id], user_id: @user.id)
    @like.destroy
    @review_length = LikeThread.where(thered_id:params[:thered_id]).length
    @review_good = LikeThread.where(thered_id:params[:thered_id],goodbad:1).length
    
    puts @review_length
    puts @review_good
    # puts 0 / 0 * 100
    if  @review_length==0 && @review_good==0
    @score = 0
    puts "aaaaaaaaaaaaaaa"
    else
    @score = @review_good / @review_length * 100
    end
    puts @score
    render json: { status: 200, message: "削除されました"  ,score:@score,review_length:@review_length,review_good:@review_good } 
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
