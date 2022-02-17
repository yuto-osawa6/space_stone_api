class Api::V1::JanlsController < ApplicationController

  def index
    @janls = Janl.all
    render :index, formats: :json
  end

  def create
    @janl = Janl.where(name:params[:janls][:name]).first_or_initialize
    if @janl.save
      render json:{status:200,genre:@janl}
    else
      render json:{status:500,message:'ジャンルの保存に失敗しました。'}
    end

  end

end