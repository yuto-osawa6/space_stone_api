class Api::V1::Acsesses::AcsessThreadsController < ApplicationController
  def create
    @acsess = AcsessThread.where(thered_id: params[:thered_id],date:params[:date].in_time_zone.all_month).first_or_create
    @acesess_count = @acsess.count + 1  
    if @acsess_update = @acsess.update(acsess_params)
      render json: { status: 200, like: @acsess_update } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end
  private
  def acsess_params
    params.require(:acsess_thread).permit(:thered_id,:date).merge(count:@acesess_count)
  end
end
