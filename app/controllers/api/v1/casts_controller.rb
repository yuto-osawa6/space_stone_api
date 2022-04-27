class Api::V1::CastsController < ApplicationController
  def index
    @janls = Cast.all
    render :index, formats: :json
  end

  def create
    @janl = Cast.where(name:params[:cast][:name]).first_or_initialize
    if @janl.save
      render json:{status:200,cast:@janl}
    else
      render json:{status:500,message:'ジャンルの保存に失敗しました。'}
    end
  end
end