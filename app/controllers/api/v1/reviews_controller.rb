class Api::V1::ReviewsController < ApplicationController
  def create 
    content = params[:content]
    review  = Review.new(reviews_params)
    if review.save
      render json: {review:review}
    else
      render json: {status:500,review:review}
    end
  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Review.find(params[:id])
    @product = @review.product

    # likecheck
      # @user = User.find(params[:user_id])
      # @like_review = LikeReview.find_by(user_id:params[:user_id])


    render :show,formats: :json
  end

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id)
  end
end
