# class Api::V1::SocialAuthController < ApplicationController
class SocialAuthController < ApplicationController

  def authenticate_social_auth_user
    #  params is the response I receive from the client with the data from the provider about the user
    puts session.to_hash
    # puts "ddddddddddddddddddddddd"
    # puts current_api_v1_user
    @user = User.signin_or_create_from_provider(params) # this method add a user who is new or logins an old one
    if @user.persisted?
      # I log the user in at this point
      sign_in(@user)
    puts session.to_hash

      # puts "ddddddddddddddddddddddd"
      # puts session.to_hash
      # puts current_api_v1_user
      # puts current_api_v1_user
      # puts "ddddddddddddddddddddddd"
      # after user is loggedIn, I generate a new_token here
      login_token = @user.create_new_auth_token
      # puts @user
      # puts current_api_v1_user
      render json: {
        # status: 'SUCCESS',
        status:200,
        message: "user was successfully logged in through #{params[:provider]}",
        headers: login_token
      },
             status: :created
    else
      render json: {
        status: 'FAILURE',
        message: "There was a problem signing you in through #{params[:provider]}",
        data: @user.errors
      },
             status: :unprocessable_entity
    end
  end
end