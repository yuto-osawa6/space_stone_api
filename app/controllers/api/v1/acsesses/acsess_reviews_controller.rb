class Api::V1::Acsesses::AcsessReviewsController < ApplicationController
  def create
    @acsess = AcsessReview.where(review_id: params[:review_id],date:params[:date].in_time_zone.all_month).first_or_create
    @acesess_count = @acsess.count + 1  
    binding.pry
    if @acsess_update = @acsess.update(acsess_params)
      render json: { status: 200, like: @acsess_update } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  private
  def acsess_params
    params.require(:acsess_review).permit(:review_id,:date).merge(count:@acesess_count)
  end
end
