class Api::V1::LikesController < ApplicationController
  def create
    # @like = current_user.likes.create(product_id: params[:product_id])
    # puts current_user.id
    @user = User.find(params[:like][:user_id])
    @like = @user.likes.new(like_params)
    # current_user
    
    if @like.save
      render json: { status: 200, like: @like } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
    # redirect_back(fallback_location: root_path)

  end

  def destroy
    @user = User.find(params[:like][:user_id])
    @like = Like.find_by(product_id: params[:product_id], user_id: @user.id)
    @like.destroy
    # doneyet
    render json: { status: 200, message: "削除されました"  } 
  end

  def check
    @user = User.find(params[:user_id])
    @liked = @user.already_liked?(params[:product_id])
    if @liked
      puts params[:product_id]
      # puts @like
      @like = Like.find_by(product_id: params[:product_id], user_id: @user.id)
      puts @like.id
    end
    render :check,formats: :json
  end

  private
  def like_params
    params.require(:like).permit(:product_id,:user_id)
  end
end
