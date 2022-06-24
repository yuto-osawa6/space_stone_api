class Api::V1::OgpsController < ApplicationController
  # before_action :authenticate

  def show
    @product = Product.find(params[:id])
    if @product.scores.length>0
    average = @product.scores.average(:value).round(1)
    else
    average = 0
    end
    image = OgpCreator.build(@product.bg_images,@product,average).tempfile.open.read
    send_data image, :type => 'image/png',:disposition => 'inline'
  end
end