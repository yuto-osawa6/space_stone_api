

  # class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  #   # include ActionView::Rendering
  #   def redirect_callbacks
  #     super
  #   end
  
  #   def omniauth_success
  #     super
  #     # return
  #     # redirect_to red_api_v1_products_path
  #   end
  
  #   def omniauth_failure
  #     super
  #   end
  
  #   protected
  #   def assign_provider_attrs(user, auth_hash)
  #     case auth_hash['provider']
  #       when 'twitter'
  #         # user.assign_attributes({
  #         #   nickname: auth_hash['info']['nickname'],
  #         #   name: auth_hash['info']['name'],
  #         #   image: auth_hash['info']['image'],
  #         #   email: auth_hash['info']['email']
  #         # })
  #         # render json: @resource, status: :ok
  #       when 'google_oauth2'
  #         user.assign_attributes({
  #           nickname: auth_hash['info']['nickname'],
  #           # nickname: "aaaaaaaa",
  #           name: auth_hash['info']['name'],
  #           image: auth_hash['info']['image'],
  #           email: auth_hash['info']['email']
  #         })
  #         puts auth_hash
  #         # render json: @resource, status: :ok
  #       # redirect_to red_api_v1_products_path

  #     else
  #       super
  #     end
  #   end
  # end


  class Api::V1::Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    # include ActionView::Rendering

  # def facebook
  #   callback_for(:facebook)
  # end

  # def twitter
  #   callback_for(:twitter)
  # end

  # def google_oauth2
  #   callback_for(:google)
  # end

  # # common callback method
  # def callback_for(provider)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #   if @user.persisted?
  #     sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
  #   else
  #     session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
  #     redirect_to new_user_registration_url
  #   end
  # end

  # def failure
  #   redirect_to root_path
  # end
#   puts "aaaaaaaaaaaaaaaaaaaaaaaaaa"

# def authenticate_social_auth_user
#   #  params is the response I receive from the client with the data from the provider about the user
#   @user = User.signin_or_create_from_provider(params) # this method add a user who is new or logins an old one
#   if @user.persisted?
#     # I log the user in at this point
#     sign_in(@user)
#     # after user is loggedIn, I generate a new_token here
#     login_token = @user.create_new_auth_token
#     render json: {
#       status: 'SUCCESS',
#       message: "user was successfully logged in through #{params[:provider]}",
#       headers: login_token
#     },
#            status: :created
#   else
#     render json: {
#       status: 'FAILURE',
#       message: "There was a problem signing you in through #{params[:provider]}",
#       data: @user.errors
#     },
#            status: :unprocessable_entity
#   end
# end
end
  
