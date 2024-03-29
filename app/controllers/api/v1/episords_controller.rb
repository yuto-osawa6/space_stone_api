class Api::V1::EpisordsController < ApplicationController
  before_action :check_user_logined, only:[:create,:destroy]
  def create
    if params[:product_id].nil?
      render json:{status:400}
      return
    end
    @episord = Episord.where(product_id:params[:product_id],episord:params[:episord]).first_or_initialize
    @episord.time = params[:time] unless params[:time].blank?
    @episord.title = params[:title] unless params[:title].blank?
    @episord.release_date = params[:release_date] unless params[:release_date].blank?

    if @episord.save
      @user = User.find_by(email:"meruplanet.sub@gmail.com")
      @thread = Thered.where(product_id:params[:product_id],episord_id:@episord.id).first_or_initialize
      @thread.title = "#{Product.find(params[:product_id]).title} #{@episord.episord}話"
      @thread.question_ids = [2,4]
      @thread.user_id = @user.id
      @thread.content = "<p>#{@episord.episord}話を見た感想をお書きください。</p>"
      @thread.save
      render json:{status:200,message:"#{@episord.episord}話の#{@episord.title}を追加・更新しました。"}
    else
      render json:{status:400}
    end
  end
  
  def destroy
    @episord = Episord.find_by(product_id:params[:product_id],episord:params[:episord])
    @thread = Thered.where(product_id:params[:product_id],episord_id:@episord.id)[0]
    @thread.destroy
    @episord.destroy

    render json:{status:200,message:"#{@episord.episord}話の#{@episord.title}を削除しました。"}
  end
end