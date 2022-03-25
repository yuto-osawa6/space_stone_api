class Api::V1::Comment::ReturnCommentReviewsController < ApplicationController
  def index
    params[:comment_review_id]
    # userは対１関係なため、includesに含めない。
    # @review = CommentReview.includes(:like_comment_reviews).find(params[:comment_review_id])
    @returncomment = ReturnCommentReview.includes(:like_return_comment_reviews,:user,return_returns: :user).where(comment_review_id:params[:comment_review_id]).page(params[:page]).per(3)
    render :index,formats: :json
  end

  def create
    begin
      @commentReview = ReturnCommentReview.new(create_params)
      @commentReview.save!
      render json: {status:200,commentReview:@commentReview}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:comment_review_id])
          @EM = ErrorManage.new(controller:"return_comment_review/create",error:"#{e}".slice(0,200))
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
  
  def returnreturn
    begin
      @commentReview = ReturnCommentReview.new(create_params2)
      @commentReview.return_return_comment_reviews.build(return_create_params)
      @commentReview.save!
      render :returnreturn, formats: :json
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:return_comment_review][:comment_review_id])
          if ReturnCommentReview.exists?(id:params[:return_return_comment_review][:return_return_id])
            @EM = ErrorManage.new(controller:"return_comment_review/return_return",error:"#{e}".slice(0,200))
            @EM.save
            render json: {status:500}
          else
            render json: {status:430}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end   
    end
  end

  def destroy
    puts params
    # {"review_id"=>"62", "comment_review_id"=>59, "id"=>"105", "return_comment_review"=>{"comment_review_id"=>59}}
    begin
      @review_comment = ReturnCommentReview.find(params[:id])
      @review_comment.destroy
      render json: {status:200}
    rescue => e
      if Review.exists?(id:params[:review_id])
        if CommentReview.exists?(id:params[:comment_review_id])
          if ReturnCommentReview.exists?(id:params[:id])
            # if ReturnCommentReview.exists?(id:params[:return_return_comment_review][:return_return_id])
              @EM = ErrorManage.new(controller:"return_comment_review/destroy",error:"#{e}".slice(0,200))
              @EM.save
              render json: {status:500}
            # else
            #   render json: {status:420}
            # end
          else
            render json: {status:420}
          end
        else
          render json: {status:410}
        end
      else
        render json: {status:400}
      end
    end
  end

  private
  def create_params
    params.require(:return_comment_review).permit(:user_id,:comment_review_id,:comment)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end
  def create_params2
    params.require(:return_comment_review).permit(:user_id,:comment_review_id,:comment).merge(reply:true)
    # params.require(:like).permit(:product_id,:user_id,:review_id,:content)
  end

  def return_create_params
    params.require(:return_return_comment_review).permit(:return_comment_review_id,:return_return_id)
  end
  
end
