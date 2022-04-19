class Api::V1::Acsesses::AcsessArticlesController < ApplicationController
  def create
    @acsess = AcsessArticle.where(article_id: params[:article_id],date:params[:date].in_time_zone.all_month).first_or_create
    @acesess_count = @acsess.count + 1
    if @acsess_update = @acsess.update(acsess_params)
      render json: { status: 200, like: @acsess_update } 
    else
      render json: { status: 500, message: "失敗しました"  } 
    end
  end

  private
  def acsess_params
    params.require(:acsess_article).permit(:article_id,:date).merge(count:@acesess_count)
  end
end
