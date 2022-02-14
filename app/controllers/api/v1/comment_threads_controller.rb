class Api::V1::CommentThreadsController < ApplicationController
  def create
    @commentReview = CommentThread.new(commentReview_params)
    # @commentReview = CommentReview.new(user_id:params[:user_id],review_id:params[:review_id],comment:params[:comment])

    # puts params[:user_id]
    # puts params[:thered_id]
    # puts params[:comment]

    @review = Thered.find(params[:thered_id])
    # puts params[:value]
    case params[:value]
    when 0 then
      @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
    when 1 then
      @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(created_at:"desc").page(params[:page]).per(5)
    when 2 then
      @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(created_at:"asc").page(params[:page]).per(5)
    else
      @review_comments = @review.comment_threads.includes(:like_comment_threads,:return_comment_threads,:user).order(Arel.sql('(SELECT COUNT(like_comment_threads.comment_thread_id) FROM like_comment_threads where like_comment_threads.comment_thread_id = comment_threads.id GROUP BY like_comment_threads.comment_thread_id) DESC')).page(params[:page]).per(5)
    end

    begin
      if  @commentReview.save
        render  :create,formats: :json
      else
        render json: {status:500}

      end
    rescue => e
      puts e
      puts "aaaaaaaaaaaa"
      puts e
      render json: {status:500}
    end
  end
  private
  def commentReview_params
    params.require(:comment_thread).permit(:user_id,:thered_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end
end
