class Api::V1::TheredsController < ApplicationController
  def create 
    content = params[:content]
    # thered.thered_question_questions.build

    @thered = Thered.new(reviews_params)
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    # puts params[:question_ids]
    puts params[:text]
    puts Thered.find(8).questions[0].thered_quesitons.ids
    @thered.question_ids
    puts "jkh"

    # thered.thered_question_questions.build
    if @thered.save
      render json: {thered:@thered}
    else
      render json: {status:500,thered:@thered}
    end
  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Thered.find(params[:id])
    @product = @review.product
    @review_comments = @review.comment_threads

    render :show,formats: :json
  end

  private 
  def reviews_params
    params.require(:thered).permit(:title,:discribe,:content,:user_id,:product_id, question_ids:[])
  end
end
