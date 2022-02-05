class Api::V1::UsersController < ApplicationController
  def setting
    @user = User.find(params[:user_id])
    if @user.update(update_params)
      render json:{status:500,message:"nicknameを更新しました。",user:@user}
    else
      render json:{status:500}
    end
  end

  def background
    @user = User.find(params[:user_id])
    # @user.bacgroundImg = params[:backgroundImage]
    if @user.update(background_params2)
      render json:{status:200,message:"背景画像を更新しました。",background:@user.image_url}
    else
      render json:{status:500}
    end
  end

  # def background
  #   @user = User.find(params[:user_id])
  #   # @user.bacgroundImg = params[:backgroundImage]
  #   if @user.update(background_params)

  #   else

  #   end
  # end

  def show
    @user = User.find(params[:user_id])
    render :show, formats: :json
  end

  private
  def update_params
    params.require(:user).permit(:nickname)
  end

  def background_params
    params.require(:user).permit(:background_image)
  end

  def background_params2
    params.permit(:bg_img)
  end
end