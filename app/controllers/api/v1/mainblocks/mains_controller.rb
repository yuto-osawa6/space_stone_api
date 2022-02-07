class Api::V1::Mainblocks::MainsController < ApplicationController
  def new_netflix
    @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).includes(:styles,:janls,:tags,:scores).order(delivery_start:"desc")
    render :new_netflix,formats: :json
  end

  def pickup
    @pickup = Product.where(pickup:true).includes(:styles,:janls,:tags,:scores)
    render :pickup,formats: :json
  end

  def new_message
    # puts params[:active] == 0
    if params[:active] == "0"
      @new_message = Newmessage.all.order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.all.count
    elsif params[:active] == "1"
      @new_message = Newmessage.where(judge:1).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:1).count
    elsif params[:active] == "2"
      @new_message = Newmessage.where(judge:2).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:2).count
    elsif params[:active] == "3"
      @new_message = Newmessage.where(judge:3).order(updated_at:"desc").page(params[:page]).per(2)
      @new_message_length = Newmessage.where(judge:3).count
    end
    render :new_message,formats: :json
  end
end