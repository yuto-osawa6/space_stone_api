class Api::V1::Mainblocks::MainsController < ApplicationController
  def new_netflix
    @new_netflix = Product.where("delivery_start <= ?", Date.today).or(Product.where(new_content:true)).includes(:styles,:janls).order(delivery_start:"desc")
    render :new_netflix,formats: :json
  end
end