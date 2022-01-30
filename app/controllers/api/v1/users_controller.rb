class Api::V1::UsersController < ApplicationController
  def setting
    @user = User.find(params[:user_id])
    if @user.update(update_params)
      render json:{status:500,message:"nicknameを更新しました。",user:@user}
    else
      render json:{status:500}
    end
  end

  private
  def update_params
    params.require(:user).permit(:nickname)
  end
end