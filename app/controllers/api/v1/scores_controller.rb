class Api::V1::ScoresController < ApplicationController
  def create
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

    @user = User.find(params[:score][:user_id])
    @score = @user.scores.new(score_params)
    @product = Product.find(params[:score][:product_id])
    # current_user
    
    if @score.save
      @score_average = @product.scores.average(:value).round(1)
      @stats = @product.scores.group(:value).count
      @stats.map{|key,value|@pss["#{key}"]=value}
      @stats_array = []
      @pss.map{|key,value|@stats_array.push(@pss[key])}

      @productScore = @product.scores

      render json: { status: 200, score: @score,score_average:@score_average,stats_array:@stats_array,productScores:@productScore} 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  def update
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

    @user = User.find(params[:score][:user_id])
    @product = Product.find(params[:score][:product_id])
    
    @score = Score.find(params[:id])
    puts params
    begin
    if  @score.update(score_params)
      @score_average = @product.scores.average(:value).round(1)



      @stats = @product.scores.group(:value).count
      @stats.map{|key,value|@pss["#{key}"]=value}
      @stats_array = []
      @pss.map{|key,value|@stats_array.push(@pss[key])}
      @productScore = @product.scores


      render json: { status: 200, score: @score,score_average:@score_average,stats_array:@stats_array,productScores:@productScore } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
    rescue => e
      puts e
    end
  end
  private
  def score_params
    params.require(:score).permit(:product_id,:user_id,:value,:music,:performance,:story,:animation,:character)
  end
end
