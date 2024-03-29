class ProductsChannel < ApplicationCable::Channel
  def subscribed
    puts params
    # puts data["id"]
    @product = Product.find(params[:id])
    stream_for @product
    @chatList = @product.chats.last(20)
    ProductsChannel.broadcast_to(@product, chatList:@chatList)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # puts @product2.inspect
    puts data
    begin
    puts data["product_id"]
    # puts "aaaa"
    # puts data[:product_id]
    @product = Product.find(data["product_id"])
    chat =Chat.new(product_id:data["product_id"],user_id:data["user_id"],message:data["message"])
    chat.save!
    @chatList = @product.chats.last(20)
  
   
    ProductsChannel.broadcast_to(@product, chatList:@chatList)
    rescue => e
      puts e
    end
  end

end
