class Api::V1::ProductsController < ApplicationController
  def index
    @products = Product.all.where(finished:0).limit(30)
    render json: { status: 200, message: "Hello World!",products: @products}
  end

  def red
    @products = Product.all.where(finished:0).limit(30)
    render json: { status: 200, message: "Hello World!43",products: @products}
    
  end
end
