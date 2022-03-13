class Api::V1::LikesController < ApplicationController
  def create
    # @like = current_user.likes.create(product_id: params[:product_id])
    # puts current_user.id
    @user = User.find(params[:like][:user_id])
    # @like_count = Product.find(params[:like][:product_id]).likes.count
    @like = @user.likes.new(like_params)
    # current_user
    
    if @like.save
      @like_count = Product.find(params[:like][:product_id]).likes.count
      render json: { status: 200, like: @like,like_count: @like_count} 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
    # redirect_back(fallback_location: root_path)

  end

  def destroy
    @user = User.find(params[:like][:user_id])
    @like = Like.find_by(product_id: params[:product_id], user_id: @user.id)
    @like.destroy
    @like_count = Product.find(params[:product_id]).likes.count
    # doneyet
    render json: { status: 200, message: "削除されました",like_count:@like_count } 
  end

  def check
    @user = User.find(params[:user_id])
    @liked = @user.already_liked?(params[:product_id])
    if @liked
      @like = Like.find_by(product_id: params[:product_id], user_id: @user.id)
    end
    # 2.0 score and review
    @score = @user.scores.where(user_id:@user.id,product_id:params[:product_id])
    @review = @user.reviews.where(user_id:@user.id,product_id:params[:product_id]).includes(:emotions)
    render :check,formats: :json
  end

  private
  def like_params
    params.require(:like).permit(:product_id,:user_id)
  end
end
