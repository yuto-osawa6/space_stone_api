class Api::V1::AcsessesController < ApplicationController
  def create
    @today = params[:current_time]
    @acsess = Acsess.where(product_id: params[:product_id],date:@today.in_time_zone.all_month).first_or_create
    @acesess_count = @acsess.count + 1

    @trends = Trend.where(product_id: params[:product_id]).first_or_create
    @trends_count = @trends.count + 1
    if @trends.updated_at.to_date != Time.now.to_date
      @trends_count = 1
    end

    if @acsess_update = @acsess.update(acsess_params)
      if @trend_update = @trends.update(product_id:params[:product_id],count:@trends_count)
        render json: { status: 200, like: @acsess_update } 
      else
        render json: { status: 500, message: "失敗しました"  } 
      end
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  private
  def acsess_params
    params.require(:acsess).permit(:product_id).merge(count:@acesess_count,date:@today)
  end

  # def trends_params
  #   params.require(:trend).permit(:product_id).merge(count:@trends_count)
  # end
end
