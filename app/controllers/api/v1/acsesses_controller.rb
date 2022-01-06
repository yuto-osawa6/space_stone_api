class Api::V1::AcsessesController < ApplicationController
  def create
    # @user = User.find(params[:like][:user_id])
    @today = params[:current_time]
    # puts today.in_time_zone.all_month
    # puts today
    @acsess = Acsess.where(product_id: params[:product_id],date:@today.in_time_zone.all_month).first_or_create
    @acesess_count = @acsess.count + 1
    # @acesess.count = @acsess.count + 1
    # @acesess.date = today
      # a.count = @acesess.count + 1
    #   a.date = today
    # end

    
    # @acsess_update = @acsess.update(acsess_params)
    # current_user
    
    if @acsess_update = @acsess.update(acsess_params)
    # if @acsess.save
      render json: { status: 200, like: @acsess_update } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  private
  def acsess_params
    params.require(:acsess).permit(:product_id).merge(count:@acesess_count,date:@today)
  end
end
