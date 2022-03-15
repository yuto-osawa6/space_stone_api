class Api::V1::ChatsController < ApplicationController

  def create
    @chat = Chat.new(create_params)
    if @chat.save

      # ActionCable.server.broadcast("chat_room_#{@chat.product_id}", { message: @chat.message })

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
