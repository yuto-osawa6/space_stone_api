class Api::V1::StaffsController < ApplicationController

  def index
    @staffs = Staff.all
    render :index, formats: :json
  end

  def create
    @style = Staff.where(name:params[:staffs][:name]).first_or_initialize
    if @style.save
      render json:{status:200,staff:@style}
    else
      render json:{status:500,message:'スタイルの保存に失敗しました。'}
    end

  end

end