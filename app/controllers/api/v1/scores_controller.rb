class Api::V1::ScoresController < ApplicationController
  before_action :check_user_logined, only:[:create,:update,:destroy]

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
    begin
      @score.save!
      @score_average = @product.scores.average(:value).round(1)
      @stats = @product.scores.group(:value).count
      @stats.map {|key,value|@pss["#{((key/10).floor+1)*10}"] = @pss["#{((key/10).floor+1)*10}"].to_i + value}
      @stats_array = []
      @pss.map{|key,value|@stats_array.push(@pss[key])}
      @productScore = @product.scores
      render json: { status: 200, score: @score,score_average:@score_average,stats_array:@stats_array,productScores:@productScore,message:{title:"「#{@product.title}」のスコアを登録しました。",select:1}} 
    rescue =>e
      if Score.exists?(user_id:params[:score][:user_id],product_id:params[:score][:product_id])
        render json: { status: 500 }
      else
        @EM = ErrorManage.new(controller:"score/create",error:"#{e}".slice(0,200))
        @EM.save
        render json: { status: 500 }
      end
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
    begin
      @score.update(score_params)
      @score_average = @product.scores.average(:value).round(1)
      @stats = @product.scores.group(:value).count
      @stats.map{|key,value|@pss["#{((key/10).floor+1)*10}"]=value}
      @stats_array = []
      @pss.map{|key,value|@stats_array.push(@pss[key])}
      @productScore = @product.scores
      render json: { status: 200, score: @score,score_average:@score_average,stats_array:@stats_array,productScores:@productScore,message:{title:"「#{@product.title}」のスコアを更新しました。",select:1} } 
    rescue => e
      if Score.exists?
        @EM = ErrorManage.new(controller:"score/update",error:"#{e}".slice(0,200))
        @EM.save
        render json: { status: 500 }
      else
        render json: { status: 500 }
      end
    end
  end

  def destroy
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
    @product = Product.find(params[:product_id])
    @score = Score.find(params[:id])
    begin
      @score.destroy!
      if @product.scores.exists?
        @average_score = @product.scores.average(:value).round(1)
      end
      # @score_average = @product.scores.average(:value).round(1)
      @stats = @product.scores.group(:value).count
      @stats.map{|key,value|@pss["#{((key/10).floor+1)*10}"]=value}
      @stats_array = []
      @pss.map{|key,value|@stats_array.push(@pss[key])}
      @productScore = @product.scores
      render json: { status: 200,score_average:@score_average,stats_array:@stats_array,productScores:@productScore,message:{title:"「#{@product.title}」のスコアを削除しました。",select:1} } 
    rescue => e
      if Score.exists?
        @EM = ErrorManage.new(controller:"score/update",error:"#{e}".slice(0,200))
        @EM.save
        render json: { status: 500 }
      else
        render json: { status: 500 }
      end
    end
    
  end

  private
  def score_params
    params.require(:score).permit(:product_id,:user_id,:value,:music,:performance,:story,:animation,:character,:all)
  end
end
