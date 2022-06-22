class ApplicationController < ActionController::API
  # include ActionController::RequestForgeryProtection
  # include ActionController::RequestForgeryProtection
  # protect_from_forgery with: :exception
  # protect_from_forgery with: :exception
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Cookies # 追加
  # before_action :check_xhr_header
  # protect_from_forgery

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
  # def set_csrf_token_header
  #   response.set_header("X-CSRF-Token", form_authenticity_token)
  # end
  

  def set_csrf_token
    cookies['CSRF-TOKEN'] = {
      domain: 'localhost:3000', # 親ドメイン
      value: form_authenticity_token
    }
  end

  def check_user_logined
    if Rails.env.production?||Rails.env.development?
      if user_signed_in?
      else
        render json:{status:401}
      end
    end
  end

  def reCaptcha_check
    if Rails.env.production?||Rails.env.development?
      siteverify_uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?response=#{params[:recaptcha_token]}&secret=#{ENV['RECAPTCHA_SECRET_KEY']}")
      response = Net::HTTP.get_response(siteverify_uri)
      json_response = JSON.parse(response.body)
      puts siteverify_uri 
      puts json_response
      puts "afaeifjeao"
      puts response
      puts json_response["success"]
      if json_response["success"] != true
        render json:{status:500}
        return
      end
    end
  end

end
