class Api::V1::CommentReviewsController < ApplicationController
  def create
    begin
      @commentReview = CommentReview.new(commentReview_params)
      @review = Review.find(params[:review_id])
      case params[:select_sort]
      when 0 then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(1).per(5)
      when 1 then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"desc").page(1).per(5)
      when 2 then
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(created_at:"asc").page(1).per(5)
      else
        @review_comments = @review.comment_reviews.include_tp_img.includes(:like_comment_reviews,:return_comment_reviews,:user).order(Arel.sql('(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id) DESC')).page(1).per(5)
      end
        @commentReview.save!
        render :create,formats: :json
    rescue => e
      if Review.exists?(id:params[:review_id])
        @EM = ErrorManage.new(controller:"comment_review/create",error:"#{e}".slice(0,200))
        @EM.save
        render json: {status:500}
      else
        render json: {status:400}
      end
    end
  end

  def destroy
    begin
      @review_comment = CommentReview.find(params[:id])
      @review_comment.destroy
      render json: {status: 200}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:id])
          @EM = ErrorManage.new(controller:"comment_review/destroy",error:"#{e}".slice(0,200))
          @EM.save
          render json: {status:500}
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end
    end
  end
  private
  def commentReview_params
    params.require(:comment_review).permit(:user_id,:review_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end
end
