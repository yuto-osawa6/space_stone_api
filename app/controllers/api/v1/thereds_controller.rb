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
    @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC'))

    render :show,formats: :json
  end

  def sort
    @review = Thered.find(params[:thered_id])
    # puts params[:value]
    case params[:value]
    when "0" then
      @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC'))
    when "1" then
      @review_comments = @review.comment_threads.order(created_at:"desc")
    when "2" then
      @review_comments = @review.comment_threads.order(created_at:"asc")
    else
      @review_comments = @review.comment_threads.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    end
    render :sort, formats: :json
  end


  private 
  def reviews_params
    params.require(:thered).permit(:title,:discribe,:content,:user_id,:product_id, question_ids:[])
  end
end
