class Api::V1::MainsController < ApplicationController
  def index
    @products = Product.where(finished:0).limit(30)
    render :index,formats: :json
  end 
end
