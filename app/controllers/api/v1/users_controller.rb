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

  def overview
    @user = User.find(params[:user_id])
    if @user.update(overview_params)
      render json:{status:200,message:"概要を更新しました。",overview:@user.overview}
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
    @pss = {
      "10"=> 0,
      "20"=> 0,
      "30"=> 0,
      "40"=> 0,
      "50"=> 0,
      "60"=> 0,
      "70"=> 0,
      "80"=> 0,
      "90"=> 0,
      "100"=> 0,
    } 

    @user = User.find(params[:user_id])

    il = @user.liked_products.joins(:janl_products).group(:janl_id).order("count(janl_id) desc").count.keys
    # Product.janls
    @genre = Janl.where(id:il).order([Arel.sql('field(id, ?)'), il]).limit(4)

    # score statics
    @score = @user.scores.group(:value).count
    @score.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
    @score_array = []
    @pss.map{|key,value|@score_array.push(@pss[key])}

    render :show, formats: :json
  end

  def likes
    @user = User.find(params[:user_id])
    @product = @user.liked_products.page(params[:page]).per(2)
    @length = @user.liked_products.count
    render json:{product: @product,length: @length}
  end

  def likeGenres
    @user = User.find(params[:user_id])

    il = @user.liked_products.joins(:janl_products).group(:janl_id).order("count(janl_id) desc").count.keys
    # Product.janls
    @genres = Janl.where(id:il).order([Arel.sql('field(id, ?)'), il])
    render json:{genres:@genres}
  end

  def scores
    @user = User.find(params[:user_id])
    @products = Product.joins(:scores).where(scores:{user_id:@user.id}).order(value: :desc).page(params[:page]).per(2)
    @length = @user.scores_products.count
    # render json:{product: @product,length: @length}
    render :scores, formats: :json
  end

  def reviews
    @user = User.find(params[:user_id])
    @reviews = @user.reviews.order(created_at: :desc).page(params[:page]).per(2)
    @review_length = @user.reviews.count
    render :reviews,formats: :json
  end

  def threads
    @user = User.find(params[:user_id])
    @reviews = @user.thereds.order(created_at: :desc).page(params[:page]).per(2)
    @review_length = @user.thereds.count
    # render :
    render :reviews,formats: :json
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

  def overview_params
    params.require(:user).permit(:overview)
  end
end