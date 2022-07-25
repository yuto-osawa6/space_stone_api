class Api::V1::SessionsController < ApplicationController
  # before_action :authenticate

  def show
    # set_csrf_token
    render json: {
      # yt:set_csrf_token,
      message:"aa"
    }, status: :ok
  end
end