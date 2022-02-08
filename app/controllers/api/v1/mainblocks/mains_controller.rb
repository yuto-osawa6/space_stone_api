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

  def calendar
    # @delivery_end = Product.where("length(delivery_end) > 0")
    # @delivery_start = Product.where("length(delivery_start) > 0")
    # today = Date.today
    now = Time.current
    from = now.ago(3.month).beginning_of_month
    to = now.since(2.month).end_of_month
    @delivery_end = Product.where(delivery_end:from...to).includes(:styles,:janls,:tags,:scores)
    @delivery_start = Product.where(delivery_start:from...to).includes(:styles,:janls,:tags,:scores)
    render :calendar,formats: :json
  end

  def worldclass
    @period = Period.order(created_at:"desc").limit(1)
    @topten = @period[0].toptens.where.not(product_id:nil).includes(product: :styles).includes(product: :janls).includes(product: :scores)
    render :worldclass,formats: :json
  end
end