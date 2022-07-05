class Api::V1::SessionUserController < ApplicationController
  def login_check 
    # request.headers.sort.map { |k, v| logger.info "#{k}:#{v}" }
    if current_user
      render :login_check,formats: :json
    else
      render json: { is_login: false, data:false}
    end
  end
end