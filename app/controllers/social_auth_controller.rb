class SocialAuthController < ApplicationController

  def authenticate_social_auth_user
    @user = User.signin_or_create_from_provider(params) # this method add a user who is new or logins an old one
    binding.pry
    if @user.persisted?
      sign_in(@user)
      login_token = @user.create_new_auth_token
      render json: {
        status:200,
        message: "user was successfully logged in through #{params[:provider]}",
        headers: login_token,
      },
             status: :created
    else
      render json: {
        status: 'FAILURE',
        message: "There was a problem signing you in through #{params[:provider]}",
        # data: @user.errors
      },
             status: :unprocessable_entity
    end
  end
end