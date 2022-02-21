class Api::V1::StudiosController < ApplicationController

  def index
    @studios = Studio.all
    render :index, formats: :json
  end

  def create
    @style = Studio.where(company:params[:studios][:company]).first_or_initialize
    if @style.save
      render json:{status:200,genre:@style}
    else
      render json:{status:500,message:'スタイルの保存に失敗しました。'}
    end

  end

end