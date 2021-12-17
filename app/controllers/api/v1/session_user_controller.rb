class Api::V1::SessionUserController < ApplicationController

  def login_check
    
    if current_user
      render json: { is_login: true, data:current_user  }
    else
      render json: { is_login: false, message: current_user }
    end

  end

end