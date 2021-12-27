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

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id)
  end
end
