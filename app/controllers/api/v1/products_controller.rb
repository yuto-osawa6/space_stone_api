class Api::V1::ProductsController < ApplicationController


  def index
    @products = Product.all.where(finished:0).limit(30)
    @genre2 = Janl.all

    # render json: { status: 200, message: "Hello World!",products: @products,styles:@styles,genres:@genres}
    # render json:
    # render 'index', formats: 'json', handlers: 'jbuilder'
    # render 'index', format: :json, handlers: 'jbuilder'
    render :index,formats: :json

  end

  def red
    @products = Product.all.where(finished:0).limit(30)
    render json: { status: 200, message: "Hello World!43",products: @products}
    
  end

end
