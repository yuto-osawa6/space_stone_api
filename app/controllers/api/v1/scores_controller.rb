class Api::V1::ScoresController < ApplicationController
  def create
    @user = User.find(params[:score][:user_id])
    @score = @user.scores.new(score_params)
    # current_user
    
    if @score.save
      render json: { status: 200, score: @score } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  def update
    @user = User.find(params[:score][:user_id])
    # @score = @user.scores.new(score_params)
    # current_user
    
    if  @score = @user.scores.update(score_params)
      render json: { status: 200, score: @score } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end
  private
  def score_params
    params.require(:score).permit(:product_id,:user_id,:value)
  end
end
