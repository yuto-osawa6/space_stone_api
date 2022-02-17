class Api::V1::StylesController < ApplicationController

  def index
    @styles = Style.all
    render :index, formats: :json
  end

  def create
    @style = Style.where(name:params[:styles][:name]).first_or_initialize
    if @style.save
      render json:{status:200,style:@style}
    else
      render json:{status:500,message:'スタイルの保存に失敗しました。'}
    end

  end

end