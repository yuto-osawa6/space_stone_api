class Api::V1::ChatsController < ApplicationController

  def create
    # nouse notest
    @chat = Chat.new(create_params)
    if @chat.save
      @product.find(@chat.product_id)
      ProductsChannel.broadcast_to(@post, @chat)
    else
    end
  end

  private 
  def create_params
    params.require(:chat).permit(:message,:user_id,:product_id)
  end
end
