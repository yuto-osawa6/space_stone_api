class Api::V1::HealthCheckController < ApplicationController
  def index
    head 200
    # render json:{message:"aa"} 
    # head :ok
  end
end
