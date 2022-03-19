class Api::V1::LikeReviewsController < ApplicationController
  def create
    @like = LikeReview.where(user_id:params[:user_id],review_id:params[:review_id]).first_or_initialize
    @like.goodbad = params[:goodbad]
    puts params[:goodbad]

    if @like.save
        @review_length = LikeReview.where(review_id:params[:review_id]).length
        @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
        @score = @review_good / @review_length.to_f * 100
        # puts  @review_length, @review_good
        # puts @review_good / @review_length * 100
        # puts (2/2) * 100
        puts @score
      render json: { status: 200, like: @like,score:@score,review_length:@review_length,review_good:@review_good,message:{title:"aaa",select:1}} 

    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @like = LikeReview.find_by(review_id: params[:review_id], user_id: @user.id)
    @like.destroy
    @review_length = LikeReview.where(review_id:params[:review_id]).length
    @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
    puts @review_length
    puts @review_good
    # puts 0 / 0 * 100
    if  @review_length==0 && @review_good==0
    @score = 0
    puts "aaaaaaaaaaaaaaa"
    else
    @score = @review_good / @review_length.to_f * 100
    end
    puts @score
    render json: { status: 200, message: "削除されました"  ,score:@score,review_length:@review_length,review_good:@review_good } 
  end

  def check
    @review_length = LikeReview.where(review_id:params[:review_id]).length
    @review_good = LikeReview.where(review_id:params[:review_id],goodbad:1).length
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
