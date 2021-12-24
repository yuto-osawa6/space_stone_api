class Api::V1::ProductsController < ApplicationController
  # before_action :authenticate_api_v1_user!, only: :red
  def left
    @styles = Style.all.includes(:products)
    @genres = Janl.all.includes(:products)

    render :left,formats: :json

  end


 

  def index
    # @products = Product.all.where(finished:0).limit(30)

    @q = Product.ransack(params[:q])
    @products = @q.result.where(finished:0).limit(30)
  
    render :index,formats: :json

  end

  def search()
    puts @grid
  end
  def red
    puts session.to_hash
    @user = current_user
    puts session.to_hash

    # puts session.to_hash
    if current_user
      render json: { is_login: true, data:current_user  }
    else
      render json: { is_login: false, message: current_user }
    end
    
    # puts session.to_hash

  end

  def show
    # puts current_user.id
    if current_user
      @liked = current_user.already_liked?(params[:id])
      @scored = current_user.scores.exists?(product_id: params[:id])
      if @liked
        @like = Like.find_by(product_id: params[:id], user_id: current_user.id)
      end
      if @scored
        @score = Score.find_by(product_id: params[:id], user_id: current_user.id)
      end
    else
      @liked = false
      @scored = false
    end
    @product = Product.find(params[:id])
    # .includes(:genres,:styles)

    render :show,formats: :json
  end 

end
