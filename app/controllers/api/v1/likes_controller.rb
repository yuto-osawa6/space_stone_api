class Api::V1::LikesController < ApplicationController
  def create
    @user = User.find(params[:like][:user_id])
    @like = @user.likes.new(like_params)
    
    begin
      if @like.save
        @product = Product.find(params[:like][:product_id])
        @like_count = @product.likes.count
        render json: { status: 200, like: @like,like_count: @like_count,message:{title:"「#{@product.title}」のお気に入りを登録しました。",select:1}}
      else
        render json: { status: 500 }
      end 
    rescue =>e
      @EM = ErrorManage.new(controller:"like/create",error:"#{e}".slice(0,200))
      @EM.save
      render json: { status: 500 }
    end
  end

  def destroy
    begin
      @user = User.find(params[:like][:user_id])
      @like = Like.find_by(product_id: params[:product_id], user_id: @user.id)
      @like.destroy
      @product = Product.find(params[:product_id])
      @like_count = @product.likes.count
      render json: { status: 200,like_count:@like_count,message:{title:"「#{@product.title}」のお気に入りを削除しました。",select:2} } 
    rescue =>e
      render json: { status: 500 }
    end
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
