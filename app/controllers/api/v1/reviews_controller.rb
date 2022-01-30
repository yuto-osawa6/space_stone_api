class Api::V1::ReviewsController < ApplicationController
  def create 
    content = params[:content]
    review  = Review.new(reviews_params)
    if review.save
      render json: {review:review}
    else
      render json: {status:500,review:review}
    end
  end

  def show
    puts params[:product_id]
    puts params[:id]
    @review = Review.find(params[:id])
    @product = @review.product
    @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))

    # puts @review_comments
    # .order((Arel.sql("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id")) "desc")
    # .find(LikeCommentReview.group(:comment_review_id).order("count(comment_review_id) desc").plunk(:comment_review_id))
    # .find([2,3,4])
    # .find(LikeCommentReview.group(:comment_review_id).order("count(comment_review_id) desc").plunk(:comment_review_id))
    # .order(Arel.sql("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id"))
    # .joins(:like_comment_reviews).group("comment_review_id").order(Arel.sql('count(comment_review_id) DESC'))
    
    # order("SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id")

    # likecheck
      # @user = User.find(params[:user_id])
      # @like_review = LikeReview.find_by(user_id:params[:user_id])


    render :show,formats: :json
  end

  def sort
    @review = Review.find(params[:review_id])
    puts params[:value]
    case params[:value]
    when "0" then
      @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    when "1" then
      @review_comments = @review.comment_reviews.order(created_at:"desc")
    when "2" then
      @review_comments = @review.comment_reviews.order(created_at:"asc")
    else
      @review_comments = @review.comment_reviews.order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC'))
    end
    render :sort, formats: :json
  end
  # ーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーーー
  def index
    @reviews = Review.page(params[:page]).per(2)
    @review_length = Review.count
    render :index,formats: :json
  end

  private 
  def reviews_params
    params.require(:review).permit(:title,:discribe,:content,:user_id,:product_id,:episord_id)
  end
end
