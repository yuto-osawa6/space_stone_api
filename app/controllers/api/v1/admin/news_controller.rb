class Api::V1::Admin::NewsController < ApplicationController
  def create
    @news = Newmessage.create(create_params)
    if @news.save
      render json:{status:200,message:"新規お知らせを追加しました。"}
    else
      render json:{status:500}
    end
  end

  private
  def create_params
    params.require(:newmessage).permit(:judge,:title,:description)

  end
end
