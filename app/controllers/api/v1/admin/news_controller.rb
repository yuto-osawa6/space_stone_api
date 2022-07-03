class Api::V1::Admin::NewsController < ApplicationController
  def create
    @news = Newmessage.create(create_params)
    if @news.save
      render json:{status:200,message:"新規お知らせを追加しました。"}
    else
      render json:{status:500}
    end
  end

  # def update
  #   begin 
  #     @news = find(params[:news_id])
  #     @news.update!(update_params)
  #     render json:{status:200}
  #   rescue
  #     render json:{status:500}
  #   end
  # end

  def destroy
    begin
      @news = Newmessage.find(params[:news_id])
      @news.delete
      render json:{status:200}
    rescue
      render json:{status:500}
    end
  end

  private
  def create_params
    params.require(:newmessage).permit(:judge,:title,:description,:information,:date)
  end
  def update_params
    params.require(:newmessage).permit(:judge,:title,:description,:information,:date)
  end
end
