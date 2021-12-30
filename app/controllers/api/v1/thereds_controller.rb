class Api::V1::TheredsController < ApplicationController
  def create 
    content = params[:content]
    thered = Thered.new(reviews_params)
    thered.thered_quesions.build
    if review.save
      render json: {thered:thered}
    else
      render json: {status:500,thered:thered}
    end
  end

  private 
  def reviews_params
    params.require(:thered).permit(:title,:discribe,:content,:user_id,:product_id,thered_question_questions_ids:[])
  end
end
