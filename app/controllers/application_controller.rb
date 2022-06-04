class ApplicationController < ActionController::API
  protect_from_forgery
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies # 追加

  # skip_before_action :verify_authenticity_token
  # helper_method :current_api_v1_user, :api_v1_user_signed_in?

  # before_action :first

  # before_action :check_xhr_header

  # private

  # def check_xhr_header
  #   return if request.xhr?

  #   render json: { error: 'forbidden' }, status: :forbidden
  # end

  # def first
  #   @styles = Style.all.includes(:products)
  #   @genres = Janl.all.includes(:products)

  #   # @styles.products.each do |a|

  #   # end
  #   # render json: { status: 201, message: "Hello World!",styles: @styles}

  # end
end
